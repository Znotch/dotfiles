#!/bin/bash

# SETTINGS (No API Key needed for Open-Meteo!)
LAT="35.85"
LON="-86.40"

# Catppuccin Mocha Colors
COLOR_CLOUD="#6c7086"
COLOR_THUNDER="#d3b987"
COLOR_LIGHT_RAIN="#73cef4"
COLOR_HEAVY_RAIN="#74c7ec"
COLOR_SNOW="#FFFFFF"
COLOR_FOG="#7f849c"
COLOR_SUN="#f9e2af"
COLOR_MOON="#FFFFFF"
COLOR_ERR="#f38ba8"
COLOR_COLD="#73cef4"        # Blue (≤50°F)
COLOR_HOT="#f38ba8"         # Red (≥86°F)
COLOR_NORMAL_TEMP="#fab387" # Orange (68-85°F)
COLOR_WHITE="#cdd6f4"       # Neutral color (51-67°F)

# Temperature Thresholds (Fahrenheit)
HOT_TEMP=86
MID_TEMP=68
COLD_TEMP=50

# API Call to Open-Meteo
URL="https://api.open-meteo.com/v1/forecast?latitude=${LAT}&longitude=${LON}&current_weather=true&temperature_unit=fahrenheit"
RESPONSE=$(curl -s "$URL")

# Check if response is valid
if [ -z "$RESPONSE" ] || [ "$(echo "$RESPONSE" | jq -r .error)" == "true" ]; then
    echo "{ \"text\": \" \", \"tooltip\": \"Weather data unavailable\", \"class\": \"weather\", \"color\": \"${COLOR_ERR}\" }"
    exit 0
fi

# Extract Data
WMO_CODE=$(echo "$RESPONSE" | jq -r .current_weather.weathercode)
# Get temperature and round to nearest integer
TEMP=$(echo "$RESPONSE" | jq -r .current_weather.temperature | awk '{print int($1 + 0.5)}')
IS_DAY=$(echo "$RESPONSE" | jq -r .current_weather.is_day) # 1 for day, 0 for night

# Determine Weather Icon and Color based on WMO codes
if [ "$WMO_CODE" -eq 0 ]; then
    # Clear sky
    if [ "$IS_DAY" -eq 1 ]; then
        ICON_COLOR=$COLOR_SUN; ICON=""
    else
        ICON_COLOR=$COLOR_MOON; ICON=""
    fi
elif [ "$WMO_CODE" -le 3 ]; then
    # Partly cloudy / overcast
    if [ "$IS_DAY" -eq 1 ]; then
        ICON_COLOR=$COLOR_SUN; ICON=""
    else
        ICON_COLOR=$COLOR_MOON; ICON=""
    fi
elif [ "$WMO_CODE" -le 48 ]; then
    # Fog
    ICON_COLOR=$COLOR_FOG; ICON=""
elif [ "$WMO_CODE" -le 57 ]; then
    # Drizzle
    ICON_COLOR=$COLOR_LIGHT_RAIN; ICON=""
elif [ "$WMO_CODE" -le 67 ] || [ "$WMO_CODE" -le 82 ]; then
    # Rain / Showers
    ICON_COLOR=$COLOR_HEAVY_RAIN; ICON=""
elif [ "$WMO_CODE" -le 77 ] || [ "$WMO_CODE" -le 86 ]; then
    # Snow
    ICON_COLOR=$COLOR_SNOW; ICON=""
elif [ "$WMO_CODE" -ge 95 ]; then
    # Thunderstorm
    ICON_COLOR=$COLOR_THUNDER; ICON=""
else
    ICON_COLOR=$COLOR_ERR; ICON=""
fi

# Determine Temperature Color
if [ "$TEMP" -le "$COLD_TEMP" ]; then
    TEMP_COLOR=$COLOR_COLD
elif [ "$TEMP" -lt "$MID_TEMP" ]; then
    TEMP_COLOR=$COLOR_WHITE
elif [ "$TEMP" -lt "$HOT_TEMP" ]; then
    TEMP_COLOR=$COLOR_NORMAL_TEMP
else
    TEMP_COLOR=$COLOR_HOT
fi

TEMP_ICON=""

# Output JSON for Waybar
echo "{ \"text\": \"<span color='${ICON_COLOR}'>${ICON}</span> <span color='${TEMP_COLOR}'>${TEMP_ICON}</span> ${TEMP}°F\", \"tooltip\": \"Weather: ${ICON} ${TEMP}°F\", \"class\": \"weather\", \"color\": \"${COLOR_WHITE}\" }"
