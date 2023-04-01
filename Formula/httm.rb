class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://ghproxy.com/https://github.com/kimono-koans/httm/archive/refs/tags/0.25.6.tar.gz"
  sha256 "916df0e1ec5d5cb1f705ce35f0ba41b50fdfa4a5c39f1fe9e684807c6fc6f851"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c0b3c45c5a05017a6586a2b4dd04104dddf26a23e435efc9e3b40344b238017"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64f402d9945bf3a833ac07302089fa6272f313da51a4cd7787a858719e3d9d71"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3ef1b02a7fa4dc13a3432af656f7a8e071338edbbe45bac51517ce97d706c1f9"
    sha256 cellar: :any_skip_relocation, ventura:        "2c76a1d37a305b16bc61157730db40c9e203ed8b66011fc7e7360ba7ad265bb4"
    sha256 cellar: :any_skip_relocation, monterey:       "b005c42e76970eed0be0d4fd47dab9d09e4f98b77e75d5a3fb6192b99b5e045d"
    sha256 cellar: :any_skip_relocation, big_sur:        "48ed47c846a1dda198f27e4666b13550fd7b8efa227c83d999c8eb4d7c83542b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c485ae66c8aea6d0718609171c9d237b08ca2a05cb93d51e79b939c77e472029"
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