require "language/node"

class LeappCli < Formula
  desc "Cloud credentials manager cli"
  homepage "https://github.com/noovolari/leapp"
  url "https://registry.npmjs.org/@noovolari/leapp-cli/-/leapp-cli-0.1.48.tgz"
  sha256 "3ca126bec09d78906bf3ba59aecc63c75eb17ee7393117b47b5fffbce9d1236f"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_sonoma:   "b9f98f22c43fe5c5e098e07f792e7cd2f94e4d04a3835fc282e5267ebac0c360"
    sha256                               arm64_ventura:  "264fcc7de47e40966a84bfa06c17b2b874afb1003e88bda55c1d278af9683c82"
    sha256                               arm64_monterey: "c2d7083077d47089277448da699a88a77bc5669d57cf5769a87952ae417ca3b5"
    sha256                               sonoma:         "19f6f35f096353202fe6043eccb39b91bc77963893c389f9dac63496836668f9"
    sha256                               ventura:        "626d817301be913c374672d90fb6e4d917450f523d94dd694a5fcc73a1b99106"
    sha256                               monterey:       "d79aeb80e46f38f3ed77ad5fc1233b1843f9a5ff4a0e73bb3594422b08cae1f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "521ad6dad90e2d9d9cfb061fbd9e0302b65fa5233671fe28637c502ceac9b92d"
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