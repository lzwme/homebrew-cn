class Ldcli < Formula
  desc "CLI for managing LaunchDarkly feature flags"
  homepage "https://launchdarkly.com/docs/home/getting-started/ldcli"
  url "https://ghfast.top/https://github.com/launchdarkly/ldcli/archive/refs/tags/v3.0.3.tar.gz"
  sha256 "173618d58c8760fd706b8fbdd2a79e59418a2fac14c0678d0ed94f4f9489bc81"
  license "Apache-2.0"
  head "https://github.com/launchdarkly/ldcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42aad206db8e19a97ba209222a4521ca6a7c248eae64558a34318d254b06b696"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "214f3c972e2b75e3cddc20703180b89889c87f93cc344cb158770b542961f2c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "850061e306941b3d8871b8a2633123a0825aa53c8c63159659b29180aae1efc0"
    sha256 cellar: :any_skip_relocation, sonoma:        "478cb0fb834ad9c7725d1c333d035809b55698bc83c079939b0be25f18cb3393"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d86c8350672bdfb9aee9b6460c0d16f23fc6637acc39e978a256232b0d506b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59b99206426943ba57caa54eadf99c0398ad20408f530cca396f1d717ca3ba0a"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"

    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"ldcli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ldcli --version")

    output = shell_output("#{bin}/ldcli flags list --access-token=Homebrew --project=Homebrew 2>&1", 1)
    assert_match "Invalid account ID header", output
  end
end