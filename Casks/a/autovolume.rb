cask "autovolume" do
  version "1.0.1"
  sha256 "41f242ce1608c7a48fab254273e0f018e9b916c1d1f5ab307e5b5534747193c8"

  url "https:github.comjesse-cAutoVolumereleasesdownloadv#{version}AutoVolume.app.zip"
  name "AutoVolume"
  desc "Tool that automatically sets the volume to a specified volume"
  homepage "https:github.comjesse-cAutoVolume"

  depends_on macos: ">= :sierra"

  app "AutoVolume.app"

  caveats do
    requires_rosetta
  end
end