class Crit < Formula
  desc "Your feedback loop with the agent: review plans and code locally"
  homepage "https://crit.md/"
  url "https://ghfast.top/https://github.com/tomasz-tomczyk/crit/archive/refs/tags/v0.23.1.tar.gz"
  sha256 "202ef05b6681299b5f8f4928fa5e148f8df7b581ef8ae2f7916630d4e3a2d10a"
  license "MIT"
  head "https://github.com/tomasz-tomczyk/crit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "52e86c46a9f488e897943761c8f4e1d85a3b5bb184568072773680bb41ebc5e0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "52e86c46a9f488e897943761c8f4e1d85a3b5bb184568072773680bb41ebc5e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "52e86c46a9f488e897943761c8f4e1d85a3b5bb184568072773680bb41ebc5e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "402ab46fddcd36c85fad8c40da208756af827bfef5fba85decf114595b7b23ba"
    sha256 cellar: :any,                 x86_64_linux:      "cf1eab20ebe4a3e82dc5f6dfd61406c9e254330384ca1317160be2363fd79178"
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