class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.54.tar.gz"
  sha256 "0fd9d9934e52aeeffc4bdce0d86b1b3bbfb67be6af62995cdba525141697220e"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "850772eaf836a449f45bf04733895b764731f855f6daf20c8bd7d0fa1853bba5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "850772eaf836a449f45bf04733895b764731f855f6daf20c8bd7d0fa1853bba5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "850772eaf836a449f45bf04733895b764731f855f6daf20c8bd7d0fa1853bba5"
    sha256 cellar: :any_skip_relocation, sonoma:        "bdec6b440551b7d6de449e3078cb69f48a3b9b348ba4ed55ec15cab552000fdf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78b7700e71af9f7ba4221e7899f19effc2e265bc7ef1e213dde4ce9acac6e2ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01f56121d791af8ff4a6eed5dd7fae526c847e51815a715aec7aeebbaee14375"
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