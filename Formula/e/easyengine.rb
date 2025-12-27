class Easyengine < Formula
  desc "Command-line control panel to manage WordPress sites"
  homepage "https://easyengine.io/"
  url "https://ghfast.top/https://github.com/EasyEngine/easyengine/releases/download/v4.10.1/easyengine.phar"
  sha256 "8a4cbfa78b1a5baed59c881716cb5233e198a9879c2fdeb1a2ac6058101cde5d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae83c0ee21d0de849c199cb3f6ec15abdd08fae50b219967fba96423f2afe803"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae83c0ee21d0de849c199cb3f6ec15abdd08fae50b219967fba96423f2afe803"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae83c0ee21d0de849c199cb3f6ec15abdd08fae50b219967fba96423f2afe803"
    sha256 cellar: :any_skip_relocation, sonoma:        "12f5c71b85d29bfff1f4b39c8069dfd3fe18842da50fcfe4fe6e12a7869d6d7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "12f5c71b85d29bfff1f4b39c8069dfd3fe18842da50fcfe4fe6e12a7869d6d7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12f5c71b85d29bfff1f4b39c8069dfd3fe18842da50fcfe4fe6e12a7869d6d7d"
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