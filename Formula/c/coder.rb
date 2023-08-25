class Coder < Formula
  desc "Tool for provisioning self-hosted development environments with Terraform"
  homepage "https://coder.com"
  url "https://ghproxy.com/https://github.com/coder/coder/archive/refs/tags/v2.1.3.tar.gz"
  sha256 "a3b37eab6465cd36c416656596e3e13e3e37d5d6ab447c09914b47e70483d029"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "183848c663a78135359273d835dab6d55291635047b7b77e59695baa3b18df61"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "222b5a377b1849047d908f2718730ca46e7d094d2810fad9e326f7633a9afa5f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a36223bad91b4962693a104f2e37d16dcabbdbdd808dec31b300e4c05273c663"
    sha256 cellar: :any_skip_relocation, ventura:        "3ad87e05e10b3fbaf084ef86bf46edeb74f4e6ba80db31dfc1877bb8733bd406"
    sha256 cellar: :any_skip_relocation, monterey:       "7453b6f7114f33ad52e2f9124383c9f72727d47162a7863f9aa1551cad695a54"
    sha256 cellar: :any_skip_relocation, big_sur:        "a02b51521ec659ca3c8a6c147e540c6cc9bd7e9e6365c12d3c116bb977d77ab6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef48d792ef5aaec9b61ae48255193532a12e47993ce93cf053782194a30f87a2"
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