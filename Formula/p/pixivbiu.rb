class Pixivbiu < Formula
  desc "Pixiv client. Easy to search, browse, and download artworks"
  homepage "https://github.com/txperl/PixivBiu"
  url "https://ghfast.top/https://github.com/txperl/PixivBiu/archive/refs/tags/v3.1.5.tar.gz"
  sha256 "dd49171a6a4895de51d6415f0bdfbeb768e6d603d6cd2f37af04df5bc49eb8cb"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2a6aea66383300432109d68651c39acd5902af0968d813212e284b1155091fd4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8d028a5db3510b085b6d21f35689a9205bfd54dfdfe67e61be29f17e562b4714"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5bc2520af13085023424c96ff3ab59cc141c4352222896a2520cd5cf0ef881be"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6c8dddafaab472968d7077b363cc859d331229ac18fe33d8a31f4f1e24ea4179"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c437137b3b1e525bfb10a87e18fbd6b9128ea63bb4e8a150adea74dbb262a6b5"
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