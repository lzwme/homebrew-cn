class WoodpeckerCli < Formula
  desc "CLI client for the Woodpecker Continuous Integration server"
  homepage "https://woodpecker-ci.org/"
  url "https://ghfast.top/https://github.com/woodpecker-ci/woodpecker/archive/refs/tags/v3.14.0.tar.gz"
  sha256 "8aa1ee7dc858cb73cb18db52e8ac9aa68733479e8fdef306166c4dc0806f272a"
  license "Apache-2.0"
  head "https://github.com/woodpecker-ci/woodpecker.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76ca026f7971d92d44a9d256b38bcdaf762ec3892a65ee6af687173f599893c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "76ca026f7971d92d44a9d256b38bcdaf762ec3892a65ee6af687173f599893c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76ca026f7971d92d44a9d256b38bcdaf762ec3892a65ee6af687173f599893c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a89b2b6acf2b77e329fabd7b28ca4e5d2240328b498645f381670c7a48c71c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03938658ecef4f8b041635362e3200a4cc5cfe54745953ba09eb4c7a11b15ec9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8516572800af0ea5ad20ed568cba5bc4b2f9875fea04f772d3eee8b98118a631"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X go.woodpecker-ci.org/woodpecker/v#{version.major}/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"
    generate_completions_from_executable(bin/"woodpecker-cli", "completion")
    # woodpecker-cli expects "pwsh", not "powershell" so we use the custom shell_parameter_format
    (pwsh_completion/"woodpecker-cli").write Utils.safe_popen_read(
      { "SHELL" => "pwsh" }, bin/"woodpecker-cli", "completion", "pwsh"
    )
  end

  test do
    output = shell_output("#{bin}/woodpecker-cli info 2>&1", 1)
    assert_match "woodpecker-cli is not set up", output

    output = shell_output("#{bin}/woodpecker-cli lint 2>&1", 1)
    assert_match "could not detect pipeline config", output

    assert_match version.to_s, shell_output("#{bin}/woodpecker-cli --version")
  end
end