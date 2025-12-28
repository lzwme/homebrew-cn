class Bookokrat < Formula
  desc "Terminal EPUB Book Reader"
  homepage "https://bugzmanov.github.io/bookokrat/index.html"
  url "https://ghfast.top/https://github.com/bugzmanov/bookokrat/archive/refs/tags/v0.2.1.tar.gz"
  sha256 "c3e65ab54bfd0bb3b4abf21139ccf07d32f15316afec69eb011ff74dd3893a1d"
  license "MIT"
  head "https://github.com/bugzmanov/bookokrat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0196823dc3ba3905fc5e3a182bf5c2d3bfea43582f7b0ad82e2aa7f1ae52ffe0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "793e450cc492e31b98dfd282912533219ec82ba9fd84d1d1bc93e136545ce850"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d3fd9ee5923c4382f41907925018ccb6b3466d45f4de3e47d4b72863ba94b2a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "078c855cec6d967ff01d0c4510ac9fea3e906b3f0d01eb186b80e50dc681500a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e1b44fdf0f48b7e60f41816495c4d4d7500bb189ab5e1514f11cdc4f863592f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9b645baad9b536dea11b58a41242f00ab0e43f7d6956b00e54a1ec0cd56978a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    pid = if OS.mac?
      spawn bin/"bookokrat"
    else
      require "pty"
      PTY.spawn(bin/"bookokrat").last
    end

    sleep 2
    assert_path_exists testpath/".bookokrat_settings.yaml"
    assert_match "Starting Bookokrat EPUB reader", (testpath/"bookokrat.log").read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end