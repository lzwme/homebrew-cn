class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.106.tgz"
  sha256 "02643571c44c2cf0bb70a658916f26fa6cdbd3484b1db44c1c8317a46416b697"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a05fee429885a0bc760d52a26ae64890d477b3bb176af89cbd4a582e1ba7b7b8"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"whistle", "start"
    system bin/"whistle", "stop"
  end
end