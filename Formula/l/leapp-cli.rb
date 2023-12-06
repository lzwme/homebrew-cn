require "language/node"

class LeappCli < Formula
  desc "Cloud credentials manager cli"
  homepage "https://github.com/noovolari/leapp"
  url "https://registry.npmjs.org/@noovolari/leapp-cli/-/leapp-cli-0.1.49.tgz"
  sha256 "2a60455d7a18b9caae30a564a036824e3444b8b6b2cd875edbc387a6e8898e8b"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_sonoma:   "9bec25efd999c0c794083360c8af63e6ced24befc34f005fa309590bbec814fb"
    sha256                               arm64_ventura:  "0f75c3f1c87d7bf61d7a94b9f987e7cba3e5f8c4f94dc58bd3408209abd5686a"
    sha256                               arm64_monterey: "99ca7dbf49c7a44b0a7ce6db97d3942c83186ca4e5d3bddd3665a78e171e7e95"
    sha256                               sonoma:         "3e0439394bb3c2853c8bdcce1d6cf0e0d771b73ce1dc080fb02656d10121c556"
    sha256                               ventura:        "cd6d3d7552ce088190d8560c6a10983191abbed388538f0bb36f3d58397ce22a"
    sha256                               monterey:       "ab5e4ad6ec4aa005507cce0b9fdc4837a4051df2b0aaa4ffce75027a49e5cb34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94eb2cb41e0064877455e71abb737d592bc690223a56e48b496bc599051e68b8"
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