class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.116.tar.gz"
  sha256 "449d968b738e3e10299c5041c61108a79f45a9b9653e8fc02d4fa87fbe929880"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c89a81ee3356f8997a2756aebe31e063dee3550d4ae87a08bd9309195d8fef5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c89a81ee3356f8997a2756aebe31e063dee3550d4ae87a08bd9309195d8fef5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c89a81ee3356f8997a2756aebe31e063dee3550d4ae87a08bd9309195d8fef5"
    sha256 cellar: :any_skip_relocation, sonoma:        "4cb59f79c05a431cc92590b7210aef9d324ca759e4c683db7e761dd237ec1b86"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "484168a74083456fa3f8ba0f0a249eb0c3f924ad2b13d1d533b35721b5c82608"
    sha256 cellar: :any,                 x86_64_linux:  "1bbe8ceaa6562bc5477be48b5f569376addf2f2a697bbd92fc12d65bf01783ff"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}]
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