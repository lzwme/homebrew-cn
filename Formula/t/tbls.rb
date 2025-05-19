class Tbls < Formula
  desc "CI-Friendly tool to document a database"
  homepage "https:github.comk1LoWtbls"
  url "https:github.comk1LoWtblsarchiverefstagsv1.85.3.tar.gz"
  sha256 "e62129b1258d0753602bc8710a5b722d39abcfba2d80e01be33f65af608ae5c0"
  license "MIT"
  head "https:github.comk1LoWtbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "03012935709bae98e01066f0e6ecba87d740acf702fa2fae4260ee69332799a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0cff67c458a225de2b9264b00c3d5df0206dc4923f3f4a459af677ebacca65f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "898e522b7a95e88bcd18f46cb127056bfe824d7cdadef35f07b924e3525316d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8e738603f19e05f38f9fbcc5cebe1de3c24178ab1a6ee95c6db1b3b26b9c1a3"
    sha256 cellar: :any_skip_relocation, ventura:       "cd202a00413aeca4b9f73d838f97601cd83e0fff86832bb13c3cff6b30e3ea33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5878b8d79328909fdfee2fb9c9f38e77d7a0c52af923deaa3a93bc47e956bab5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "440eaad88a958ae85624e2753c8ead29aca79ecdc9f9b1e2f68d0f593420a07c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comk1LoWtbls.version=#{version}
      -X github.comk1LoWtbls.date=#{time.iso8601}
      -X github.comk1LoWtblsversion.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"tbls", "completion")
  end

  test do
    assert_match "unsupported driver", shell_output(bin"tbls doc", 1)
    assert_match version.to_s, shell_output(bin"tbls version")
  end
end