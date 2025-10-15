class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.8.tar.gz"
  sha256 "e0e4a529f6b3ac11de9b9fb271f019e1681fd9dde86b7a2481e006d9dfcf1435"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8cdaf40d8c7a3756cd191472106d3163d76da7f8c1eb6b8059773d5ad63d6931"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8cdaf40d8c7a3756cd191472106d3163d76da7f8c1eb6b8059773d5ad63d6931"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8cdaf40d8c7a3756cd191472106d3163d76da7f8c1eb6b8059773d5ad63d6931"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f2f103eae9407d5016f935839e8cd986e768464a1e10ec6d7b07afb7586ca8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6bca2dcddf82adf824f8199686fa7acfdf350390176606d174adac4ffdf77ab7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4644b259e8a61138366f3474d2e3a6a7f5ebcf59c434899dde84258d5629b4a3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/infisical --version")

    output = shell_output("#{bin}/infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}/infisical agent 2>&1")
    assert_match "starting Infisical agent", output
  end
end