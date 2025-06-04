cask "distroav" do
  version "6.1.0"
  sha256 "6229c333f216624a1dd251f314dbf74b1b7b8b452c35f837a97407e1c938d1ef"

  url "https:github.comDistroAVDistroAVreleasesdownload#{version}distroav-#{version}-macos-universal.pkg",
      verified: "github.comDistroAVDistroAV"
  name "DistroAV"
  desc "NDI integration for OBS Studio"
  homepage "https:distroav.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on cask: "libndi"

  pkg "distroav-#{version}-macos-universal.pkg"

  # The pkg installs the plugin files to LibraryApplication Supportobs-studioplugins
  # however OBS Studio expects them to be in ~LibraryApplication Supportobs-studioplugins
  # so we create symlinks to correctly link the plugin files for OBS Studio.
  postflight do
    puts "Creating #{token} symlinks in ~LibraryApplication Supportobs-studioplugins"
    target = Pathname.new("~LibraryApplication Supportobs-studioplugins").expand_path
    source = "LibraryApplication Supportobs-studioplugins"

    FileUtils.mkdir_p target
    File.symlink("#{source}distroav.plugin", "#{target}distroav.plugin")
    File.symlink("#{source}distroav.plugin.dSYM", "#{target}distroav.plugin.dSYM")
  end

  uninstall_preflight do
    puts "Removing #{token} symlinks from in ~LibraryApplication Supportobs-studioplugins"
    target = Pathname.new("~LibraryApplication Supportobs-studioplugins").expand_path

    if File.symlink?("#{target}distroav.plugin")
      File.unlink("#{target}distroav.plugin", "#{target}distroav.plugin.dSYM")
    end
  end

  uninstall pkgutil: [
    "'org.distroav.distroav'",
    "org.distroav.distroav",
  ]

  # No zap stanza required
end