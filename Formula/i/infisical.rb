class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.104.tar.gz"
  sha256 "ebfd48758f117e2ef497d2258b1d01d781387c6905ba75135417bf20bd82574d"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "102de29b4f09d4d994c1f8304ad00b501dffdccb665b7dca8e148bb44504d419"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "102de29b4f09d4d994c1f8304ad00b501dffdccb665b7dca8e148bb44504d419"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "102de29b4f09d4d994c1f8304ad00b501dffdccb665b7dca8e148bb44504d419"
    sha256 cellar: :any_skip_relocation, sonoma:        "191052f0bec1c9e6f1bd12d9fe03493350d77ee2f8093991d4bbfc20e9f9b674"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8dee77f2733ca499cbcfac168c9167411494aaf3292dfed9401da145256a1b2"
    sha256 cellar: :any,                 x86_64_linux:  "5648cd476717e9c1059c0586d4eb43b04787c67aecf4318f70d95e316d1b0e5a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"infisical", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/infisical --version")

    output = shell_output("#{bin}/infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}/infisical agent 2>&1")
    assert_match "starting Infisical agent", output
  end
end