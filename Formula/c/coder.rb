class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://ghproxy.com/https://github.com/coder/coder/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "10d0e7f84c045788cb0d7d58c828fba25b5f6bb80a8d9b41cbbd7fbc92eb563e"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f838d7671d9a7c6c262e96c5be3f138d3d7f204525561182d1d95c669df33e41"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dfd32548fd91bceabddf20df356772838c9247fd77c15d68c32531fbaac866be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f2de167d4a8bc7e4b0651857acd69cdba5fa8547ab1f8fae49d125a3a990d34"
    sha256 cellar: :any_skip_relocation, ventura:        "1671ffd4ae74a2a684f621d76abc58a304f5c3493bc195648028c436538c3498"
    sha256 cellar: :any_skip_relocation, monterey:       "e044c0078898ec05bdac602e5a00c7c017fec0d1969bd85f264cf432f5b8a4b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c0da7c91ba850c0945eb9eda6022df8800ea472fb7771e63a2fcfeabf635d79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4583d23abb7afdc361e53a3b1fbe3a33d480769dd9456a76df5fb2360aeeaf55"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/coder/coder/v2/buildinfo.tag=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/coder"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/coder version")
    assert_match "You are not logged in", shell_output("#{bin}/coder netcheck 2>&1", 1)
    assert_match "postgres://", shell_output("#{bin}/coder server postgres-builtin-url")
  end
end