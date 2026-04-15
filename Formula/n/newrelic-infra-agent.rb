class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.73.1",
      revision: "b4661314be94ffb3f5cb71ff88515617f3e1b8c2"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c387224798056975e4582fd991e4bffb722805457a7554f2f73f5e4b23041cd2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b34c9e604c9b5be7c15aff6a0160f0e6830135ff6de747b81b9f08be77aa53f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3428c7cb7abbedaa28b85d7664dff183d93942eb9d3ab8217665d6f58cb50547"
    sha256 cellar: :any_skip_relocation, sonoma:        "a226cd7d6d05571090f4d06dbebb9655d65eb43cfc41eb7977bd1c911057c0d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ad996d64374c937002ecf5733ce491020d89d1b65ce537810073212fae99ef4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ca77c2ee36ea6424639822b7de8a7467bc44b20187ed7b39cea2274e48ebb9f"
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
    bin.install "dist/#{os}-newrelic-infra_#{os}_#{goarch}/newrelic-infra"
    bin.install "dist/#{os}-newrelic-infra-ctl_#{os}_#{goarch}/newrelic-infra-ctl"
    bin.install "dist/#{os}-newrelic-infra-service_#{os}_#{goarch}/newrelic-infra-service"
    (var/"db/newrelic-infra").install "assets/licence/LICENSE.macos.txt" if OS.mac?
    (etc/"newrelic-infra").mkpath
    (var/"log/newrelic-infra").mkpath
  end

  service do
    run [opt_bin/"newrelic-infra-service", "-config", etc/"newrelic-infra/newrelic-infra.yml"]
    log_path var/"log/newrelic-infra/newrelic-infra.log"
    error_log_path var/"log/newrelic-infra/newrelic-infra.stderr.log"
  end

  test do
    output = shell_output("#{bin}/newrelic-infra -validate")
    assert_match "config validation", output
  end
end