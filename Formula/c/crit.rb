class Crit < Formula
  desc "Your feedback loop with the agent: review plans and code locally"
  homepage "https://crit.md/"
  url "https://ghfast.top/https://github.com/tomasz-tomczyk/crit/archive/refs/tags/v0.20.3.tar.gz"
  sha256 "0f44cd8bd155c440aad4cf44b64ca2b0e4c3fabc3848f74753320a4c1e3390bc"
  license "MIT"
  head "https://github.com/tomasz-tomczyk/crit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d92cc58a0366be37b5434e5ae492c3b607857b8df4d4a859458b19a915d8f3c6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d92cc58a0366be37b5434e5ae492c3b607857b8df4d4a859458b19a915d8f3c6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d92cc58a0366be37b5434e5ae492c3b607857b8df4d4a859458b19a915d8f3c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3c58da312369983eee1d7c08ef01ddc5a20e367f5fb5b8d38829f76515742edb"
    sha256 cellar: :any,                 x86_64_linux:      "bae24ddf3f192fc787407ed2715e9d23a3c52f7e1262925a97eb8fd900c1d78a"
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