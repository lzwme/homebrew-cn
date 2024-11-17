class Easyengine < Formula
  desc "Command-line control panel to manage WordPress sites"
  homepage "https:easyengine.io"
  url "https:github.comEasyEngineeasyenginereleasesdownloadv4.7.6easyengine.phar"
  sha256 "817ba7db159a6506b063e8182c25c050703f0efb55b2c925247cb1d52f3cd300"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb082589eef23f02a17115c1bfcb68312d7b8a73a2d71e4540bc02d547bdff51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb082589eef23f02a17115c1bfcb68312d7b8a73a2d71e4540bc02d547bdff51"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eb082589eef23f02a17115c1bfcb68312d7b8a73a2d71e4540bc02d547bdff51"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d8fdbe32af2219061c8dca65faf717363a2b66be30c283b3c67a611d7100e7c"
    sha256 cellar: :any_skip_relocation, ventura:       "1d8fdbe32af2219061c8dca65faf717363a2b66be30c283b3c67a611d7100e7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d87c4c70c1ec6e9981ed9d03c95302349a16b32c0946b1ae70b2306881eb1cb6"
  end

  depends_on "dnsmasq"
  depends_on "php"

  # Keg-relocation breaks the formula when it replaces `usrlocal` with a non-default prefix
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

    system bin"ee", "config", "set", "locale", "hi_IN"
    output = shell_output("#{bin}ee config get locale")
    assert_match "hi_IN", output

    output = shell_output("#{bin}ee cli info")
    assert_match OS.kernel_name, output
  end
end