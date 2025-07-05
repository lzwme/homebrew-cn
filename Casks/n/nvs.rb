cask "nvs" do
  version "1.7.1"
  sha256 "0df024c8c8489a63674cac148e766eab0cc2de3cd8e97c6caffd8e117a09863e"

  url "https://ghfast.top/https://github.com/jasongin/nvs/archive/refs/tags/v#{version}.tar.gz"
  name "Node Version Switcher"
  desc "Cross-platform tool for switching between versions and forks of Node.js"
  homepage "https://github.com/jasongin/nvs"

  no_autobump! because: :requires_manual_review

  installer script: {
    executable: "nvs-#{version}/homebrew/install.sh",
    args:       ["#{caskroom_path}/latest"],
  }

  uninstall trash: "~/.nvs"

  # No zap stanza required

  caveats <<~EOS
    NVS installs all Node.js versions to ~/.nvs by default.
    To change this behavior, remove ~/.nvs and make the
    following modification to your shell profile:
      export $NVS_HOME=/your/preferred/location
  EOS
end