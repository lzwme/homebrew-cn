class Easyengine < Formula
  desc "Command-line control panel to manage WordPress sites"
  homepage "https://easyengine.io/"
  url "https://ghproxy.com/https://github.com/EasyEngine/easyengine/releases/download/v4.6.5/easyengine.phar"
  sha256 "2477012abffeefe8b4008d669e0e632d086d3e7cdc2db6f04e5495355df6eb62"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9d4ae6600854547c67ba66aca863376050c78b9b3b804a04b6b633aa7547932b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d4ae6600854547c67ba66aca863376050c78b9b3b804a04b6b633aa7547932b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d4ae6600854547c67ba66aca863376050c78b9b3b804a04b6b633aa7547932b"
    sha256 cellar: :any_skip_relocation, ventura:        "74580985fb32c7f3592e2e72b6a9970e7d7bff26a6636c56aee56718398d3cf1"
    sha256 cellar: :any_skip_relocation, monterey:       "74580985fb32c7f3592e2e72b6a9970e7d7bff26a6636c56aee56718398d3cf1"
    sha256 cellar: :any_skip_relocation, big_sur:        "74580985fb32c7f3592e2e72b6a9970e7d7bff26a6636c56aee56718398d3cf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d4ae6600854547c67ba66aca863376050c78b9b3b804a04b6b633aa7547932b"
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