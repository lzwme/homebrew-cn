cask "obs-ndi" do
  version "4.13.2"
  sha256 "fe3d054399bb104afe67a9751702950995ce53f76c660647b44e3287cceb4bcc"

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