class Easyengine < Formula
  desc "Command-line control panel to manage WordPress sites"
  homepage "https://easyengine.io/"
  url "https://ghfast.top/https://github.com/EasyEngine/easyengine/releases/download/v4.9.1/easyengine.phar"
  sha256 "62055e75aec57fc604ae43e264d017dd4ad38406e30e13c8e6eb31499f6f5691"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "381553f152d7382660fdebc0b1e3c362d9578f59cf4b567b292ad49ae46187a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "381553f152d7382660fdebc0b1e3c362d9578f59cf4b567b292ad49ae46187a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "381553f152d7382660fdebc0b1e3c362d9578f59cf4b567b292ad49ae46187a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "d55461d1ffce6841468dd7df538620c0ef4f97f974736c971f52c3d18c62791c"
    sha256 cellar: :any_skip_relocation, ventura:       "d55461d1ffce6841468dd7df538620c0ef4f97f974736c971f52c3d18c62791c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d55461d1ffce6841468dd7df538620c0ef4f97f974736c971f52c3d18c62791c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d55461d1ffce6841468dd7df538620c0ef4f97f974736c971f52c3d18c62791c"
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