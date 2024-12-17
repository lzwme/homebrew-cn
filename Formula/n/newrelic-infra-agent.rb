class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https:github.comnewrelicinfrastructure-agent"
  url "https:github.comnewrelicinfrastructure-agent.git",
      tag:      "1.58.1",
      revision: "b3d3c5a7ef899f2054d55a9cc6f38a6f56ac2eee"
  license "Apache-2.0"
  head "https:github.comnewrelicinfrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d390e726e6d3fa2b70ea987c01e00ab4b1ae31e5de84930ae090778731c33fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7517ef82d9d8048ba09b35489adf85e38e5713ac91bd38a8d27b61cfc54406a1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8700aa54203275566eb62691440b0dcb4d040e5f34adc1d4e90034d4799e14d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f9de32bab0555647993bee844e98ddab3355b070e9fc9e119757018cd0c5329"
    sha256 cellar: :any_skip_relocation, ventura:       "ab1ae4602e37402e4f3e16b45797e0b97c16a1d62701f3de0ba58255f987e0ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "770df53e2d6daa18302126a221f5e822c85e25a404de7a1f9fd067139d6612b5"
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