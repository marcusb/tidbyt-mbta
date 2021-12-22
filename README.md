MBTA real-time schedule for the Tidbyt
======================================

This is an app for the [Tidbyt](https://tidbyt.com) that displays MBTA arrival times.
Data is provided by the MBTA's [API](https://www.mbta.com/developers).

![Tidbyt showing MBTA bus times](https://lh3.googleusercontent.com/ka3Vxr3lR9mi52xE8oi0W_MPwaLjsnUxbNv4fhOVZc83ZQuy40HLrKvgdtpnkEG47pLcxP4fkuoHh_nc3nQ=w293-h220)

Usage
-----

1. Sign up for the MBTA's developer API and get an API key.
2. Clone the repo.
3. In `bus.star`, set `API_KEY` to your key.
4. Set `DEFAULT_STOP` to the ID of your stop.

To run the app in a web browser:
```
pixlet serve bus.star
```

Or you can push it to your Tidbyt - refer to the [Pixlet docs](https://github.com/tidbyt/pixlet) for that.
