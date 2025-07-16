class Dish < Formula
  desc "Lightweight monitoring service that efficiently checks socket connections"
  homepage "https://github.com/thevxn/dish"
  url "https://ghfast.top/https://github.com/thevxn/dish/archive/refs/tags/v1.12.tar.gz"
  sha256 "34ec121544c4c762668fb5cfb4fd7eb4b90f22fc5b31389e3b7a1b0f944d7f05"
  license "MIT"
  head "https://github.com/thevxn/dish.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5898415f5408e0f6e6518c899447db33e8948bbf63c38b831393b836deb74ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5898415f5408e0f6e6518c899447db33e8948bbf63c38b831393b836deb74ff"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a5898415f5408e0f6e6518c899447db33e8948bbf63c38b831393b836deb74ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba62cbf941427e3887632c23ca8618f83228701f3291405c751a1f1f65aa744b"
    sha256 cellar: :any_skip_relocation, ventura:       "ba62cbf941427e3887632c23ca8618f83228701f3291405c751a1f1f65aa744b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75845779ff76860ac8d689de90b8058834c4e343644462ae5fd9807ba488cd82"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/dish"
  end

  test do
    ouput = shell_output("#{bin}/dish https://example.com/:instance 2>&1", 3)
    assert_match "error loading socket list: failed to fetch sockets from remote source", ouput
  end
end