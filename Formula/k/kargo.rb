class Kargo < Formula
  desc "Multi-Stage GitOps Continuous Promotion"
  homepage "https://kargo.io/"
  url "https://ghfast.top/https://github.com/akuity/kargo/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "501a0b85f5dfdef73da97fa8a689c5adce54ad3ebd42b140a14265711384eb1f"
  license "Apache-2.0"
  head "https://github.com/akuity/kargo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eebe883dff50741385c18ffb740c0bcc21c118ce9c90a312091fa3afe915f069"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce9fa8e99bf669bd55e487961360207f97e8763b6ceb535e5bf69b44b8802370"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7110a5e44f026e82cbb45a2f8ec1382f8d269ed4ec5fd47316544121ddc0be88"
    sha256 cellar: :any_skip_relocation, sonoma:        "488c9aab350463e1ce6fde110706d3b97af21e66013ea06f82283277fc7f281c"
    sha256 cellar: :any_skip_relocation, ventura:       "4ddbbbf4ece28c4ec1c45e92f9a9c648653ce0b387b067d2e9a28fd173a0bbec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c3ee86c5abe2eaebbb3b6ed657d90a5d01a0fccfbafd025c4600515a1b42dd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74ed13d1339188b21d98769e7404dea8cb9b98d94118733c20c25da7eb21a9ef"
  end

  depends_on "go"

  def install
    ldflags = %W[
      -s -w
      -X github.com/akuity/kargo/pkg/x/version.version=#{version}
      -X github.com/akuity/kargo/pkg/x/version.buildDate=#{time.iso8601}
      -X github.com/akuity/kargo/pkg/x/version.gitCommit=#{tap.user}
      -X github.com/akuity/kargo/pkg/x/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"kargo", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kargo version")

    assert_match "kind: CLIConfig", shell_output("#{bin}/kargo config view")
  end
end