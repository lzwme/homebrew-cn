cask "obs-ndi" do
  version "4.14.1"
  sha256 "3b7920d66afabf0f5ca6e1567ef9c48ced112799e8ba28f27621f26b8d544bd8"

  url "https:github.comobs-ndiobs-ndireleasesdownload#{version}obs-ndi-#{version}-macos-universal.pkg"
  name "obs-ndi"
  desc "NDI integration for OBS Studio"
  homepage "https:github.comobs-ndiobs-ndi"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on cask: "libndi"

  pkg "obs-ndi-#{version}-macos-universal.pkg"

  # The pkg installs the plugin files to LibraryApplication Supportobs-studioplugins
  # however OBS Studio expects them to be in ~LibraryApplication Supportobs-studioplugins
  # so we create symlinks to correctly link the plugin files for OBS Studio.
  postflight do
    puts "Creating #{token} symlinks in ~LibraryApplication Supportobs-studioplugins"
    target = Pathname.new("~LibraryApplication Supportobs-studioplugins").expand_path
    source = "LibraryApplication Supportobs-studioplugins"

    FileUtils.mkdir_p target
    File.symlink("#{source}obs-ndi.plugin", "#{target}obs-ndi.plugin")
    File.symlink("#{source}obs-ndi.plugin.dSYM", "#{target}obs-ndi.plugin.dSYM")
  end

  uninstall_preflight do
    puts "Removing #{token} symlinks from in ~LibraryApplication Supportobs-studioplugins"
    target = Pathname.new("~LibraryApplication Supportobs-studioplugins").expand_path

    File.unlink("#{target}obs-ndi.plugin", "#{target}obs-ndi.plugin.dSYM")
  end

  uninstall pkgutil: [
    "'fr.palakis.obs-ndi'",
    "com.newtek.ndi.runtime",
    "fr.palakis.obs-ndi",
  ]

  # No zap stanza required
end