require "language/node"

class LeappCli < Formula
  desc "Cloud credentials manager cli"
  homepage "https://github.com/noovolari/leapp"
  url "https://registry.npmjs.org/@noovolari/leapp-cli/-/leapp-cli-0.1.46.tgz"
  sha256 "543b6f30202c6c0f7ca7b146b64273286a57e2dac87d4c99a8303d404a9e5796"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_sonoma:   "18c68ab6d6a4840b292da793908fe39939fb2b61a565fc86a4941cffa6986fdd"
    sha256                               arm64_ventura:  "d57bf66c43f5c65d4327297d3870ad3f062f508b5547e0b4bcdec22bc8b63a28"
    sha256                               arm64_monterey: "f17d598bca1150d307b0d6a40cdd3cfb73fc0bff5c798eb2f53ffa2df0d19fdc"
    sha256                               sonoma:         "b1acf5dec524a30bc85af01fa8c32696172a48ffbc3bdbb8402a1383ab030556"
    sha256                               ventura:        "6bdefc141baa7d4c1e91f0c69fc2eb9a19d29a58e2a45614d1e02631445d94e4"
    sha256                               monterey:       "6248c6aef75d8d0155c4819429d1ae95a05ae1e5de17c36e3d9746ebf035de0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "489da79d90f5555765fa5ceaffa139531017cbb9b1b8f00146228d5d943115d7"
  end

  depends_on "pkg-config" => :build
  depends_on "node"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "libsecret"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  def caveats
    <<~EOS
      This formula only installs the command-line utilities by default.

      Install Leapp.app with Homebrew Cask:
        brew install --cask leapp
    EOS
  end

  test do
    assert_match "Leapp app must be running to use this CLI",
      shell_output("#{bin}/leapp idp-url create --idpUrl https://example.com 2>&1", 2).strip
  end
end