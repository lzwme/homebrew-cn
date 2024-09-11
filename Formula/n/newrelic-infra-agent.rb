class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https:github.comnewrelicinfrastructure-agent"
  url "https:github.comnewrelicinfrastructure-agent.git",
      tag:      "1.57.0",
      revision: "08ce4b4ef52c4ecb5cacdc4b52bdd7021958c0c5"
  license "Apache-2.0"
  head "https:github.comnewrelicinfrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "cca6d0008f0d7de5ce20b2fb3a2f9d7da7e21cdb6f7418d98853b717dae4463b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6a4ab48a520c7b5745d2b2b8a25933e5e62f2d62da4efce13115c8ecebbe3264"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d2155911d3998505f87387858ef5c427678207091bdf5f225ee6631b02f7f38a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01e6821812ead5b97f6d3c1a30937ba758850609ae5a2a3f1fab39daa2adefd2"
    sha256 cellar: :any_skip_relocation, sonoma:         "b453852243bbe585e328e9176a41ba389c5471933d79858caf2c6e2e9c52cadc"
    sha256 cellar: :any_skip_relocation, ventura:        "75cb54f38fe461e5861167a6c13652948d771cb4257c018bf5d3d950cae33e60"
    sha256 cellar: :any_skip_relocation, monterey:       "254e47b3df9f33c4ef6ff35b836ee7aeeff6882efd4c2a3da75fdf8058b83312"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a9046336c9d18b01885383b97d3b5bfa070199ae2521c86252158cfca5235da"
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