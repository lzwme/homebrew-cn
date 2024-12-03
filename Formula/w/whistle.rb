class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https:github.comavwowhistle"
  url "https:registry.npmjs.orgwhistle-whistle-2.9.90.tgz"
  sha256 "e7069ef57d8722624801f45cff9bcea2d6a1c101010d45baafd911f3a49acefa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1f3d714dd06800b1456bb065829120b13ebdc7789a750707bf030eaf75c3ef4d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    (testpath"package.json").write('{"name": "test"}')
    system bin"whistle", "start"
    system bin"whistle", "stop"
  end
end