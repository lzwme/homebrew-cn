class Easyengine < Formula
  desc "Command-line control panel to manage WordPress sites"
  homepage "https://easyengine.io/"
  url "https://ghfast.top/https://github.com/EasyEngine/easyengine/releases/download/v4.13.1/easyengine.phar"
  sha256 "afc069b78a6a8c0e9b8c75681f61244aabe4577b26f4174d559ab03885ae8bf8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0ad999daeda2c80ea5e50f62722bb8f0d315e21661182973a2eadb3e28b8b382"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0ad999daeda2c80ea5e50f62722bb8f0d315e21661182973a2eadb3e28b8b382"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0ad999daeda2c80ea5e50f62722bb8f0d315e21661182973a2eadb3e28b8b382"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6faf7befaf34cd87e7c49bf68342da085e3019773de24b6f4d7c1ffc63cca40b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6faf7befaf34cd87e7c49bf68342da085e3019773de24b6f4d7c1ffc63cca40b"
  end

  depends_on "dnsmasq"
  depends_on "php"

  # Keg-relocation breaks the formula when it replaces `/usr/local` with a non-default prefix
  on_macos do
    on_intel do
      pour_bottle? only_if: :default_prefix
    end
  end

  def install
    bin.install "easyengine.phar" => "ee"
  end

  test do
    return if OS.linux? # requires `sudo`

    system bin/"ee", "config", "set", "locale", "hi_IN"
    output = shell_output("#{bin}/ee config get locale")
    assert_match "hi_IN", output

    output = shell_output("#{bin}/ee cli info")
    assert_match OS.kernel_name, output
  end
end