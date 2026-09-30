class Pixivbiu < Formula
  desc "Pixiv client. Easy to search, browse, and download artworks"
  homepage "https://github.com/txperl/PixivBiu"
  url "https://ghfast.top/https://github.com/txperl/PixivBiu/archive/refs/tags/v3.1.4.tar.gz"
  sha256 "d530b902b8ccb8f749388d0da44380c8e9eb560741a5c23d65708bbe013d8a09"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d5d3ab05b6c71134a6ba29e57f1312f0f9def3ae0d05b5caeb632a7e2b54dfd7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "adb9f7d6aeb1ca522e8ab2fff1ac0bba368d582dc86b1bc01f9a42444cf4d1ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "68e307ca7d2bfdcfa7489ee1774eff8f555a2b2590cffe70ea3f51712793d428"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b651775ebab9af0c427242b321fc91c1af381eeaab0cc3bb5edcdb2ee0ea065f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c9b2b6f1677a9d9aca2ce26a461845a0becfe7465ed55b32859f05851326cccb"
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