class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://ghproxy.com/https://github.com/kimono-koans/httm/archive/refs/tags/0.26.3.tar.gz"
  sha256 "15418ba6ba14ffe60aa49f5e9a7ae9dcc4bd08dd45a945998c089a031c9cd3cc"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd824e536820e6cb12a61cc31598f9fcf828baf0f6b6370f519cb76492f75c9c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99f3068874d560f0a513fcb285298072e5d00e44faa856f515dbb22a5c45a27b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "70e80ca4add6ef1ea78923bfdd4b6585f74acc143a3b22d5dc022141f44922bb"
    sha256 cellar: :any_skip_relocation, ventura:        "909d3d7e864e50d0f59380dce2215e40700bce50c8a5fca0fa26cab9d609c3ac"
    sha256 cellar: :any_skip_relocation, monterey:       "5dbc8a1b8d4de157c0d0f50f038100ce3bcbd78cca4da25f76b6cc2bdacdf598"
    sha256 cellar: :any_skip_relocation, big_sur:        "b0e69d9638ce090e914afbf0dc4ef67a5cdfe3635f5b5f0b0f88677338e4db7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3da862244fae167ba1c3fa4dd2f53fbce4014366c92ea8d52fc19d8bfc242121"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "httm.1"
  end

  test do
    touch testpath/"foo"
    assert_equal "Error: httm could not find any valid datasets on the system.",
      shell_output("#{bin}/httm #{testpath}/foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}/httm --version").strip
  end
end