class Easyengine < Formula
  desc "Command-line control panel to manage WordPress sites"
  homepage "https://easyengine.io/"
  url "https://ghfast.top/https://github.com/EasyEngine/easyengine/releases/download/v4.13.0/easyengine.phar"
  sha256 "95e5cb2e67596bbb27ba3c7e60ac916864fdef5220b1da0856ec1df14651dafb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0d82b8233999440443f4e2e44ec85eb0143fbc2d5182d56afd4a69cce8c13dd0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0d82b8233999440443f4e2e44ec85eb0143fbc2d5182d56afd4a69cce8c13dd0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0d82b8233999440443f4e2e44ec85eb0143fbc2d5182d56afd4a69cce8c13dd0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f355b4a1f05581804ea765837677df6f0a0c4b9fa1672449bfdd4535c178b967"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f355b4a1f05581804ea765837677df6f0a0c4b9fa1672449bfdd4535c178b967"
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