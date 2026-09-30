class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.80.5",
      revision: "2022083bacc239b5748feee44265b0e341a9de91"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a7261bf0ef5fcf199bef800a95479652c87f59a6ef0f3ddf05af11c51485281b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "05f56711368eb5b33529c9cb538c77e74960e005ee5c8df21ab9d683015e7dcc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fc812fb9d1e3f5be97d94bd7316614691c66649d502d91015d3b5f66d2cdead4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e8228dbc1bf90e7b8672a9c449ac667600c96cc9113e7761d0df62bf52a2e001"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "89603fb4bc27f579c6c466bb36e6c957631c3b97d0ce7e5da3c0b1f4a9e39a48"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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