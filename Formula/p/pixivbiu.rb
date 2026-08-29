class Pixivbiu < Formula
  desc "Pixiv client. Easy to search, browse, and download artworks"
  homepage "https://github.com/txperl/PixivBiu"
  url "https://ghfast.top/https://github.com/txperl/PixivBiu/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "d657b9da0f2c845b75b2418fad30f622e895d12c386557797073b4c3e000a348"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "403308d0003d9790f73e4583c1aa61337ed7ef32f16a25cc630e10f677dee63b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d11e288bdd8c924384be9d4a755e078fb14b13a00c0f12aeda1dd61c32b412ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c218bc328b1f6796db3b3bda670f0d821c67a62c783a39f7c8c8564a86498bdf"
    sha256 cellar: :any_skip_relocation, sonoma:        "c91acf8beee46b53c2f708f8dcf32209c89219cfd0238ea9e2ef996a213b1a01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b3424df7f7933517faedfb79be37828ef6431518f049ccd98020601a8f0aefd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1791b748f2fe74b5cb369b1a2fc05b586f2ff26004a817698dd04da9d6d30f1"
  end

  depends_on "bun" => :build
  depends_on "go" => :build

  def install
    system "make", "dist", "VERSION=#{version}"
    bin.install "bin/pixivbiu"
  end

  test do
    port = free_port
    data_dir = testpath/"data"
    data_dir.mkdir
    ENV["PIXIVBIU_DATA_DIR"] = data_dir
    ENV["PIXIVBIU_SERVER_PORT"] = port.to_s

    pid = spawn bin/"pixivbiu", "open=false"
    assert_match '"status":"ok"', shell_output("curl -fsS --retry 10 --retry-connrefused --retry-delay 1 'http://127.0.0.1:#{port}/api/v1/health'")
  ensure
    Process.kill "SIGINT", pid
    Process.wait pid
  end
end