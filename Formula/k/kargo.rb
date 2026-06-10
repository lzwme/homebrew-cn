class Kargo < Formula
  desc "Multi-Stage GitOps Continuous Promotion"
  homepage "https://kargo.io/"
  url "https://ghfast.top/https://github.com/akuity/kargo/archive/refs/tags/v1.10.6.tar.gz"
  sha256 "1ea8d3285212e545c3aa52ec48b2ac221f12be7ea4a6e3444a0d6d08502f919b"
  license "Apache-2.0"
  head "https://github.com/akuity/kargo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b815f95389f08da769bbd31f5b49e716da1c33ed772352f3ce018cfa1999e16"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0d745cc3780d5100bc216c274081fffcfb342d86b262c1e596db0cc16d06fe5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d97a9121c06605ba2b05ffc9ae5be7183dba14539a5229f5434306b7f67c327"
    sha256 cellar: :any_skip_relocation, sonoma:        "cdd864f18e7a10e2dc777a3e9753ba78718cf94b166b1a566b4eaf8543eaf25a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "91d5b30e42a521e9b00239731ec807906ddd77dea16cfcbb9a76887de5a98f46"
    sha256 cellar: :any,                 x86_64_linux:  "0cb632db1c05eded7612df0e5b695c14e0d084defc96955df45d2a80d88d8ba4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/akuity/kargo/pkg/x/version.version=#{version}
      -X github.com/akuity/kargo/pkg/x/version.buildDate=#{time.iso8601}
      -X github.com/akuity/kargo/pkg/x/version.gitCommit=#{tap.user}
      -X github.com/akuity/kargo/pkg/x/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"kargo", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kargo version")

    assert_match "kind: CLIConfig", shell_output("#{bin}/kargo config view")
  end
end