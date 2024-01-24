class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https:github.comnewrelicinfrastructure-agent"
  url "https:github.comnewrelicinfrastructure-agent.git",
      tag:      "1.48.4",
      revision: "a125c5ec08d51e375d6432b8c44e9d5c78f4af5c"
  license "Apache-2.0"
  head "https:github.comnewrelicinfrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a6f09882222e248ee1687980fff4ace3374383c3ff4f043bc3f40cff278c5f7e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b01eb665ffebb33942664cbb43d1f2cade819c11a7db95dec7d636612cb32ede"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d063b71dc97f16db2e293e26b821ce7890b748ba9a2ca3f374b2bf18d8419ac3"
    sha256 cellar: :any_skip_relocation, sonoma:         "eefa0a12755baef50dc554118d5100e051016062fdbb311dffbb5d0bee3a9e41"
    sha256 cellar: :any_skip_relocation, ventura:        "97bff527bffb3a039159ecda388e30d0c5a5a2476fc9672bcba77e7821a7b1d4"
    sha256 cellar: :any_skip_relocation, monterey:       "b6b36d4e3a36b87ae3e60384b47799f1c0c06d5293e9ac2722291f48ef46d6fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "537d39285977ce1a4c5f594d2c10d2c54a42b2b96d415d27fc719ce955855560"
  end

  depends_on "go" => :build

  def install
    goarch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    os = OS.kernel_name.downcase
    ENV["VERSION"] = version.to_s
    ENV["GOOS"] = os
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ENV["GOARCH"] = goarch

    system "make", "dist-for-os"
    bin.install "dist#{os}-newrelic-infra_#{os}_#{goarch}newrelic-infra"
    bin.install "dist#{os}-newrelic-infra-ctl_#{os}_#{goarch}newrelic-infra-ctl"
    bin.install "dist#{os}-newrelic-infra-service_#{os}_#{goarch}newrelic-infra-service"
    (var"dbnewrelic-infra").install "assetslicenceLICENSE.macos.txt" if OS.mac?
  end

  def post_install
    (etc"newrelic-infra").mkpath
    (var"lognewrelic-infra").mkpath
  end

  service do
    run [opt_bin"newrelic-infra-service", "-config", etc"newrelic-infranewrelic-infra.yml"]
    log_path var"lognewrelic-infranewrelic-infra.log"
    error_log_path var"lognewrelic-infranewrelic-infra.stderr.log"
  end

  test do
    output = shell_output("#{bin}newrelic-infra -validate")
    assert_match "config validation", output
  end
end