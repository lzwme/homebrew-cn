class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://ghproxy.com/https://github.com/walles/moar/archive/refs/tags/v1.15.1.tar.gz"
  sha256 "6aad63f2ee339d6abc8d9ab5e3cedac750fec1f47617b5afcac6a9107475b883"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "780032d9f7db543d359a77bd15098944718a8bfbf7d978591d90319bda93346e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "780032d9f7db543d359a77bd15098944718a8bfbf7d978591d90319bda93346e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "780032d9f7db543d359a77bd15098944718a8bfbf7d978591d90319bda93346e"
    sha256 cellar: :any_skip_relocation, ventura:        "0ddc095b62b180a4c0c8b9d5e1016c2aa11e7aa42a392f45bbb8f6d1bbc1b6bf"
    sha256 cellar: :any_skip_relocation, monterey:       "0ddc095b62b180a4c0c8b9d5e1016c2aa11e7aa42a392f45bbb8f6d1bbc1b6bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ddc095b62b180a4c0c8b9d5e1016c2aa11e7aa42a392f45bbb8f6d1bbc1b6bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c93cd5fc9ed52ec47b4553d3438947bd5bfaad3a134e9b1c0e9687c2f081f58e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
    man1.install "moar.1"
  end

  test do
    # Test piping text through moar
    (testpath/"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}/moar test.txt").strip
  end
end