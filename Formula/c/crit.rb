class Crit < Formula
  desc "Your feedback loop with the agent: review plans and code locally"
  homepage "https://crit.md/"
  url "https://ghfast.top/https://github.com/tomasz-tomczyk/crit/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "4cef188305449846c6bc39db0134d85b4f803ba853d496aa7c368e02c1bf6142"
  license "MIT"
  head "https://github.com/tomasz-tomczyk/crit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f95c6018331a8a2ec27cb32128e8a3143ae5bbf746a972a2411eec280bc824db"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f95c6018331a8a2ec27cb32128e8a3143ae5bbf746a972a2411eec280bc824db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f95c6018331a8a2ec27cb32128e8a3143ae5bbf746a972a2411eec280bc824db"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b4c4956238e93691fa10ff89abb845fabc21c02ae5825708362fa6ad71806055"
    sha256 cellar: :any,                 x86_64_linux:      "44cbb3b2452d54391cbb9c30642b28fad4b489be0a9c7bb2c2d126dba67a6356"
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