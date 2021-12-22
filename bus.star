load("http.star", "http")
load("time.star", "time")
load("render.star", "render")

API_KEY = "YOUR_KEY_HERE"

DEFAULT_STOP = "22751"

URL = "https://api-v3.mbta.com/predictions"

def main(config):
    timezone = config.get("timezone") or "America/New_York"
    stop = config.get("stop") or DEFAULT_STOP

    params = {
        "sort": "arrival_time",
        "include": "route",
        "filter[stop]": stop
    }
    rep = http.get(URL, params = params, headers = {"x-api-key": API_KEY})
    if rep.status_code != 200:
        fail("MBTA API request failed with status {}".format(rep.status_code))

    incl = rep.json()["included"]
    rows = []
    for prediction in rep.json()["data"][0:2]:
        route = prediction["relationships"]["route"]["data"]["id"]
        route = find(incl, lambda o: o["type"] == "route" and o["id"] == route)["attributes"]
        r = renderSched(prediction, route, timezone)
        if r:
            rows.extend(r)
            rows.append(render.Box(height=1, width=64, color="#ccffff"))

    return render.Root(
        child=render.Column(children=rows, main_align="start")
    )

def renderSched(prediction, route, timezone):
    tm = prediction["attributes"]["arrival_time"]
    if not tm:
        return []
    t = time.parse_time(tm).in_location(timezone)
    arr = t - time.now().in_location(timezone)
    dest = route["direction_destinations"][int(prediction["attributes"]["direction_id"])].upper()
    return [render.Row(
        main_align="space_between",
        children=[
            render.Stack(
                children=[
                    render.Circle(
                        diameter=12, color="#ffc72c",
                        child=render.Text(content=route["short_name"], color="#000", font="CG-pixel-3x5-mono")
                    )
                ]
            ),
            render.Box(width=2, height=5),
            render.Column(
                main_align="start",
                cross_align="left",
                children=[
                    render.Marquee(
                        width=50,
                        child=render.Text(
                            content=dest,
                            height=8,
                            offset=-1,
                            font="Dina_r400-6"
                        )
                    ),
                    render.Text(
                        content="{} min".format(int(arr.minutes)),
                        height=8,
                        offset=-1,
                        font="Dina_r400-6",
                        color="#ffd11a"
                    )
                ]
            )
        ],
        cross_align="center"
    )]

def find(xs, pred):
    for x in xs:
        if pred(x):
            return x
    return None
