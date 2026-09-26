class ShuttleCli < Formula
  desc "CLI for handling shared build and deploy tools between many projects"
  homepage "https://github.com/lunarway/shuttle"
  url "https://ghfast.top/https://github.com/lunarway/shuttle/archive/refs/tags/v0.25.1.tar.gz"
  sha256 "7112b1b562aee1f2b9af17362aa18891a02571ab405d64719fb67ce887a3c5a3"
  license "Apache-2.0"
  head "https://github.com/lunarway/shuttle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "aefec12638d4390492d12eca20ed2a7c414176d493f2fe9ab51f530dd0619854"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "aefec12638d4390492d12eca20ed2a7c414176d493f2fe9ab51f530dd0619854"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "aefec12638d4390492d12eca20ed2a7c414176d493f2fe9ab51f530dd0619854"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5e8c5bcaddb5bdbebb85518aa3746cb916c473c48beabec58b683168d9580d5f"
    sha256 cellar: :any,                 x86_64_linux:      "ce45f1a3ea7684bff6e8096717437959b4db0d6fc89eb821ef3a329099efa4a0"
  end

  depends_on "go" => :build

  conflicts_with "cargo-shuttle", because: "both install `shuttle` binaries"

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/lunarway/shuttle/cmd.version=#{version}
      -X github.com/lunarway/shuttle/cmd.commit=#{tap.user}
    ]
    system "go", "build", *std_go_args(output: bin/"shuttle", ldflags:)

    generate_completions_from_executable(bin/"shuttle", "completion", shells: [:bash, :zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shuttle version")

    (testpath/"shuttle.yaml").write <<~YAML
      plan: 'https://github.com/lunarway/shuttle-example-go-plan.git'
      vars:
        docker:
          baseImage: golang
          baseTag: stretch
          destImage: repo-project
          destTag: latest
    YAML

    assert_match "Plan:", shell_output("#{bin}/shuttle config")

    output = shell_output("#{bin}/shuttle telemetry upload 2>&1", 1)
    assert_match "SHUTTLE_REMOTE_TRACING_URL or upload-url is not set", output
  end
end