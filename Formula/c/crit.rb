class Crit < Formula
  desc "Your feedback loop with the agent: review plans and code locally"
  homepage "https://crit.md/"
  url "https://ghfast.top/https://github.com/tomasz-tomczyk/crit/archive/refs/tags/v0.21.1.tar.gz"
  sha256 "73096cc8a38ba809721d5f31683f911f52c14e2c5c0ee8e36b832fc77d756096"
  license "MIT"
  head "https://github.com/tomasz-tomczyk/crit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3980bdf5d0185180f607cc3eacb59f1b15b258a87f2d3f10b355ac54e22bb5f3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3980bdf5d0185180f607cc3eacb59f1b15b258a87f2d3f10b355ac54e22bb5f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3980bdf5d0185180f607cc3eacb59f1b15b258a87f2d3f10b355ac54e22bb5f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5bba7cd17c59f3b060466a8e2ce0c8868f5953e4141e73f4bd2909a7eea0d4e2"
    sha256 cellar: :any,                 x86_64_linux:      "6069180293295b61ce803472658d447af88825c74a42b9f414de7d756e67dcd1"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.commit=brew
      -X main.date=#{time.iso8601[0, 10]}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/crit"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/crit --version")

    (testpath/"hello.md").write("# Hello\n")
    system bin/"crit", "comment", "-o", testpath, "hello.md:1", "looks good"

    assert_path_exists testpath/"reviews"
  end
end