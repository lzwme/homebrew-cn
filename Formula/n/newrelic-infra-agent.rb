class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https:github.comnewrelicinfrastructure-agent"
  url "https:github.comnewrelicinfrastructure-agent.git",
      tag:      "1.65.0",
      revision: "fa8332b18557528f481016a5bc90c16f356427f6"
  license "Apache-2.0"
  head "https:github.comnewrelicinfrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55b4d968d0466c9657cac0f0c142e88aa6fa688fb3664295fe30444a410ae381"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "758e9f322d1a77cb60b1341334341695130cddf6e5bb2bb6215902deba45e6fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a760d39c9b4a93f66147a24fd3780952ea17737d641c4a988e92090673c36488"
    sha256 cellar: :any_skip_relocation, sonoma:        "1aacd427ae83abf6acaeba80501e1941a6864e7976397d91b2a8038591db9002"
    sha256 cellar: :any_skip_relocation, ventura:       "5dea3e91994e75209fa638dea202c729608130973ff8767a20dae34df068d905"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd29316b20d1311ea1ee0fc00b8f4d2488f387931b6480fa3081589dfeff5feb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5db0f724e72a85ef84421d9a0c0d830138cfd143fe95417525bc75d3a73ab0c4"
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