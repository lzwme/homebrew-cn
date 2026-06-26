class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.98.tar.gz"
  sha256 "de014735dff55d53eadf200dd8842accb21a284762dadec25f6c8fb078c3c405"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5050e83a2541f81d320d7607a5fc527c5e662b1507dcd3992a4501b1748c9cb4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5050e83a2541f81d320d7607a5fc527c5e662b1507dcd3992a4501b1748c9cb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5050e83a2541f81d320d7607a5fc527c5e662b1507dcd3992a4501b1748c9cb4"
    sha256 cellar: :any_skip_relocation, sonoma:        "386da778c7e885e1ac7da8b59193b6f363b227a88f7a9b47ca1c060307d20ecd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e395705f75e34acea7ce6b1cc3a5217c48df3652f6af47b640905bbb8470ef70"
    sha256 cellar: :any,                 x86_64_linux:  "72e7cbfc913f3eac803b72bec563768c1ed9bd45523768266a8a2b24dc7c0205"
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