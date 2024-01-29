require "languagenode"

class LeappCli < Formula
  desc "Cloud credentials manager cli"
  homepage "https:github.comnoovolarileapp"
  url "https:registry.npmjs.org@noovolarileapp-cli-leapp-cli-0.1.59.tgz"
  sha256 "2d3790391a41e81725ecbd4207820b3744b62c9bf1ea5e9a9ff18489ce2c2bfd"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_sonoma:   "6d696738e6ffac7a64b07953c19929da033d013003618d0b8dd052abb2606c5b"
    sha256                               arm64_ventura:  "fd3383505aa6343dfae2d744c99f5f2eedec0a03ed0a45ca32f5de9cc900f1d9"
    sha256                               arm64_monterey: "67d3316ca11784956848f2bb3f5dd64d8feafe9633d26f1ff4af232d8e372159"
    sha256                               sonoma:         "f566f00d1500b765dac33219d65949a9d5821d194ba8c6c718c0734fa9390371"
    sha256                               ventura:        "9ec162cb8a8ec1370745a83e33e04ac2f9e6d04be07bd618cdfd256405b4c7e3"
    sha256                               monterey:       "762c25e4cd0fdab91f7b1087f6e6e242c0d9875507f875356c6136213fc7ca39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8b6e72b3c90334edbf008202dcac26bce74c890688497771f374fb81e2ad344"
  end

  depends_on "pkg-config" => :build
  depends_on "node"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "libsecret"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
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
      shell_output("#{bin}leapp idp-url create --idpUrl https:example.com 2>&1", 2).strip
  end
end