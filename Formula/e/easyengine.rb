class Easyengine < Formula
  desc "Command-line control panel to manage WordPress sites"
  homepage "https://easyengine.io/"
  url "https://ghfast.top/https://github.com/EasyEngine/easyengine/releases/download/v4.10.0/easyengine.phar"
  sha256 "ec1aaf25ce9ae105f59226e0a3458fdc06d51245d4f48871f18512d13629fc38"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1de7881f87fb33e0e2d1c5e68f6299ef75d73475000fa4babcbd0a9f45b972e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1de7881f87fb33e0e2d1c5e68f6299ef75d73475000fa4babcbd0a9f45b972e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1de7881f87fb33e0e2d1c5e68f6299ef75d73475000fa4babcbd0a9f45b972e"
    sha256 cellar: :any_skip_relocation, sonoma:        "919230f6ee552e085d9ec0a447ad70147f63edebeb02e7d5aed1090658eedf3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "919230f6ee552e085d9ec0a447ad70147f63edebeb02e7d5aed1090658eedf3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "919230f6ee552e085d9ec0a447ad70147f63edebeb02e7d5aed1090658eedf3c"
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