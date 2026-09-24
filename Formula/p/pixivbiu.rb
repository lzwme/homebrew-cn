class Pixivbiu < Formula
  desc "Pixiv client. Easy to search, browse, and download artworks"
  homepage "https://github.com/txperl/PixivBiu"
  url "https://ghfast.top/https://github.com/txperl/PixivBiu/archive/refs/tags/v3.1.3.tar.gz"
  sha256 "80dc43f53e14492d996bf05ba874ec239e1c0037e98f255c869e3501807e3cea"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "60fbae790d4c5478c7dd04625d1e02d1954b268c22b869b2f71f621d20502f4c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e825ed3a08a5a84fbb9690f3e8289ee2fc16c8caba98c21c9b27eda9e0ffb820"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9fcfbffc13ddce5d77b55781e39f5335a2c70d52671bcba1dd3389a7b2cb5b2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ef63d04d62ca39018ae8dadae029dd35ea3a4639ecdbe3740ef8c8d835ff70be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c0dae49e19edb5d4ead2ade3b82ad92e04d78c12c2db2902d7ba6da10638d82b"
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