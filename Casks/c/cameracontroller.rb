cask "cameracontroller" do
  version "1.4.0"
  sha256 "8a46dcb20a8d8898d4c47540f636e990ca3e3401c0ff062043efe5cc33d39dda"

  url "https:github.comItaybreCameraControllerreleasesdownloadv#{version}CameraController.zip"
  name "CameraController"
  desc "Control USB Cameras from an app"
  homepage "https:github.comItaybreCameraController"

  livecheck do
    url "https:raw.githubusercontent.comItaybreCameraControllermasterappcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "CameraController.app"

  zap trash: [
    "~LibraryApplication Scriptscom.itaysoft.CameraController",
    "~LibraryApplication Scriptscom.itaysoft.CameraController.Helper",
    "~LibraryApplication SupportCameraController",
    "~LibraryContainersCameraController",
    "~LibraryPreferencescom.itaysoft.CameraController.plist",
  ]
end