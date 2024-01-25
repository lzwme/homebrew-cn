require "languagenode"

class LeappCli < Formula
  desc "Cloud credentials manager cli"
  homepage "https:github.comnoovolarileapp"
  url "https:registry.npmjs.org@noovolarileapp-cli-leapp-cli-0.1.58.tgz"
  sha256 "6c6baea16a1cf3f084fb58fd044d2fdbaa763ea47242a6ca7492a84e90645923"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_sonoma:   "a256e4361b30ecdf7fbda0e6f097d3f04ee056e7774cf207c7c2d6dec2704994"
    sha256                               arm64_ventura:  "fd2b7244ca53301d904a9cea05cd9d27467305e03ed78db9234f615e4c8321f0"
    sha256                               arm64_monterey: "27c86a179344fac7b523446fb873afb514c3201b41087d7e72bf29f0dee2fda7"
    sha256                               sonoma:         "4a96066e411419d817d2a2fa51ad4ae6de173e68528d00d7b32e720081d86430"
    sha256                               ventura:        "8cc19c9c693516af2ad5a728142f7f4ba882f08ecfd6caa48f4a59cdf625d7e0"
    sha256                               monterey:       "21bfde6025b508f9c5cdb9e967352a94af2c48dbe28dca68d163f37485ea60af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ed6fdd6c75d0fdece55a6fc457c3175045a3a8175f296da169618a4e82531f4"
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