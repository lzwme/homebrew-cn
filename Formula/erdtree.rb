class Erdtree < Formula
  desc "Multi-threaded file-tree visualizer and disk usage analyzer"
  homepage "https://github.com/solidiquis/erdtree"
  url "https://ghproxy.com/https://github.com/solidiquis/erdtree/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "6f296241e6bd47f9901dc4b6a711d842de73d3d66adadadfdd7709fc50637580"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7a42a64a20e3a5704386922abfbecce1232ecaad5c75d1263e46cf97a22534f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd5b447b695ffc92658308e8e506ac9d8796a3fa5ce8f8055be7fab51f212741"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bfde47ec8c9fe3e6e8d351647219ad430f56acadd1fefd8ae1c2690fef3fec91"
    sha256 cellar: :any_skip_relocation, ventura:        "273703b622069ac76c3fb24b319002f792d08bd55d0c2cc73c6145a38fa7d82a"
    sha256 cellar: :any_skip_relocation, monterey:       "496a8ce0e3244e59f892bfaed78ec233cda16f971ca62aba8ca7142e610981f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "93d51d7b9c576f5d6360a77322858b06f1d264ea09ef1e0f22c0cfe051a030e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ce0b6f89190cef79328078aa6dc4b1b0924d20b57e42469f7266ed1cf7ebf4b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch "test.txt"
    assert_match "test.txt", shell_output("#{bin}/erd")
  end
end