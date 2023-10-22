class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://ghproxy.com/https://github.com/anchore/grype/archive/refs/tags/v0.72.0.tar.gz"
  sha256 "6788af9f34fb37b93858b17184e01268ba997e10cc8671ba9fe16d8e338f01e6"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a27bd2e4ef0a7ba3db0ee123c68d4340a9ac818e95810bbb5764ab00c6d27cdf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b9f47029d7e283c9504b4bf88700316fc08ad129eaac8d8e2021187d996d931"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e954f39f264a3996120ef37a0ef20bc44d6c7bb0b8812843da575b04a025e98"
    sha256 cellar: :any_skip_relocation, sonoma:         "9d33d3862a9bb3d6f3780b913929cc477de36c23e9a4457326b72d54ff9fd454"
    sha256 cellar: :any_skip_relocation, ventura:        "1149fc32bba5e40c89031091c11d0491059530d688a988f7df96deea7dd23d71"
    sha256 cellar: :any_skip_relocation, monterey:       "705c1abb2995d76755d243eda16ca26b0400383a3b84e4d9b108a8bc30a04707"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6e3d28bc4f2768d294024c16ca9cb6937e3c6bb66e0371fd18689c8aff0ab17"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=brew
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/grype"

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database metadata not found", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "Update available", shell_output("#{bin}/grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}/grype version")
  end
end