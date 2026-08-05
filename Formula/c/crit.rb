class Crit < Formula
  desc "Your feedback loop with the agent: review plans and code locally"
  homepage "https://crit.md/"
  url "https://ghfast.top/https://github.com/tomasz-tomczyk/crit/archive/refs/tags/v0.18.3.tar.gz"
  sha256 "1211e3d293c8665c9b23cd79e6d94fe527162b9157025d720f7d1643866932c9"
  license "MIT"
  head "https://github.com/tomasz-tomczyk/crit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c0175d60dca3667bb0627dc01451974836435a6a63c7910fc8333b7235f7cb6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c0175d60dca3667bb0627dc01451974836435a6a63c7910fc8333b7235f7cb6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c0175d60dca3667bb0627dc01451974836435a6a63c7910fc8333b7235f7cb6"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c690ceb744df6ceedaadfc101f193380a0d66cee7b5a9c5c8423755e3b587b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbbdef63c27d8df404935e614e246efaa154195fde39bd12d98ea3e54c5e4283"
    sha256 cellar: :any,                 x86_64_linux:  "da4d73b41e86858999722505621c8f5d9d64b75ac8a0369018807cad33972787"
  end

  depends_on "go" => :build

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