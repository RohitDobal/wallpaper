# Flutter Wallpaper App

## Objective

Create a simple Wallpaper App using Flutter. The app allows users to browse and set wallpapers on their device.

## Features
### Home Screen

- Display a list/grid of wallpapers.
- A Floating Action Button switches the view between list and grid.
- Each wallpaper is a clickable thumbnail that navigates to a detailed view.
- Infinite scrolling is implemented on the home screen using pagination to load more wallpapers as the user scrolls down.

### Detail Screen

- Display the full-size wallpaper.
- Provide options to:
    - Set the wallpaper as the home screen background.
    - Set the wallpaper as the lock screen background.

The cleaned data was saved as `Cleaned_Data.csv`.

## API Integration
Uses the Unsplash API to fetch wallpapers.

## State Management
Uses GetX for state management.

## Packages Used
- get: ^4.6.6
- http: ^1.2.1
- flutter_wallpaper_manager: ^0.0.4
- wallpaper: ^1.1.1
- flutter_cache_manager: ^3.1.2
- cached_network_image: ^3.2.0
- wallpaper_manager_flutter: ^0.0.2
- shimmer: ^2.0.0

## Usage
- Launch the app to see the home screen displaying a grid of wallpapers.
- Use the Floating Action Button to switch between list and grid views.
- Scroll down to load more wallpapers.
- Tap on any wallpaper to navigate to the detail screen.
- On the detail screen, choose to set the wallpaper as the home screen or lock screen background.

## Screenshots
