class Easyengine < Formula
  desc "Command-line control panel to manage WordPress sites"
  homepage "https:easyengine.io"
  url "https:github.comEasyEngineeasyenginereleasesdownloadv4.7.4easyengine.phar"
  sha256 "ddc0be3d3ea2a21af496d1d56e2c1822771e799faddc6d066f74eb7b2da4e356"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8f62d014c8c5c4778c267f6c4e1a7671db3822300e387746938fc5304c665e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8f62d014c8c5c4778c267f6c4e1a7671db3822300e387746938fc5304c665e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e8f62d014c8c5c4778c267f6c4e1a7671db3822300e387746938fc5304c665e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "d76f128dda355228141dbbfdf15442e83f94b75ef4b64a19a48fb18949add328"
    sha256 cellar: :any_skip_relocation, ventura:       "d76f128dda355228141dbbfdf15442e83f94b75ef4b64a19a48fb18949add328"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6e1c80fc3b9f305f1812d493700f193bd9439fb0edb7190c9e16877b84d877e"
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