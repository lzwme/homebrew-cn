class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.94.tar.gz"
  sha256 "a5048470d1820fb26b47ad16d19e268e09c676ef84013b68371a8f4e448d9f2c"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "748260f656c9254e2ba093ea7063ca812c7a3b99fc5ca3f8f765615ec8229f8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "748260f656c9254e2ba093ea7063ca812c7a3b99fc5ca3f8f765615ec8229f8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "748260f656c9254e2ba093ea7063ca812c7a3b99fc5ca3f8f765615ec8229f8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "0b4c4485ea3898bdff31a40f0f75635a640585ff3ffe5056171c4c63537424fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da5ccf6bd15def1f14126a2c1829ebdf76f85119ecbfd5712c3ed539ef2902de"
    sha256 cellar: :any,                 x86_64_linux:  "c950ae83694e8b4230af1fcca934b485181d452223c6ee331bc08c87ca791dd5"
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