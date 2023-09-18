class Fx < Formula
  desc "Terminal JSON viewer"
  homepage "https://fx.wtf"
  url "https://ghproxy.com/https://github.com/antonmedv/fx/archive/refs/tags/30.0.0.tar.gz"
  sha256 "bd9c5827c83ba791c13bacbc6223ea190fd9c9d5d03520e6966f59973dccc049"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc748fc53237100fd4945021d91f48df08226906c13cc345d0db6d31f103ce52"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc748fc53237100fd4945021d91f48df08226906c13cc345d0db6d31f103ce52"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc748fc53237100fd4945021d91f48df08226906c13cc345d0db6d31f103ce52"
    sha256 cellar: :any_skip_relocation, ventura:        "349f0c1be36fb425f0f7a6cad2a0ff7ea47e04e15d43f726f85d9e32d5c26a94"
    sha256 cellar: :any_skip_relocation, monterey:       "349f0c1be36fb425f0f7a6cad2a0ff7ea47e04e15d43f726f85d9e32d5c26a94"
    sha256 cellar: :any_skip_relocation, big_sur:        "349f0c1be36fb425f0f7a6cad2a0ff7ea47e04e15d43f726f85d9e32d5c26a94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bcc8f998238e6b60ccb5de76e7dff070bb08104351e24bbd5c3d1f390fb9d7b"
  end

  depends_on "go" => :build
  depends_on "node"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_equal "42", pipe_output("#{bin}/fx .", 42).strip
  end
end