require "language/node"

class LeappCli < Formula
  desc "Cloud credentials manager cli"
  homepage "https://github.com/noovolari/leapp"
  url "https://registry.npmjs.org/@noovolari/leapp-cli/-/leapp-cli-0.1.40.tgz"
  sha256 "b45bc1e9fb91f5695313afa6eb87400d6865ffbbd5311e942dad1893cc4d7c9a"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_ventura:  "52527f1ce53ca3384aaf48a46d1f6d0199609f64ae1a13d4f4483b7a4b9aee4d"
    sha256                               arm64_monterey: "88631d31c64b5b0fc65d2bdea89e2be7c91d6cced4db9e4dcc1638ae4cbc452e"
    sha256                               arm64_big_sur:  "bb00ef08e010a742b722260a7019c4b5369880e8beabc2fb052a3bd05f17fe6e"
    sha256                               ventura:        "3aa825dbff8ddf476b6a2a5b54063cfca06c90d36ca9abda72c20e5b832b9a12"
    sha256                               monterey:       "f2551db334b4ad6d85a9ddaf099b8408f0eba84462dd4d5939c4ae3809701b75"
    sha256                               big_sur:        "71b28d9e462000ffb19b83039b43f71ca1406a6de5186b42b241fc4e6de8efcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5dfbef8cf870a1b08e013ab8c162956edbc0b435fbf8f355f45b76b8c323ffe"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "node"

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