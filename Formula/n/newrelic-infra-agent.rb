class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.80.7",
      revision: "43bd381fe48959cbfd2464c608c05e10e9418380"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0189e2aa4b2541533c081df5f2be99e46a355b250b3ac66ed6b58578a74a1e2c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "dadac1a6c43b7f83184a332c528f632852cdc92b9eb3b065c2872c397fd3ae94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7a8ebaf2d81038e9fe624327498b56f6b98188d4ffe7272e87cedcc3a55817a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cea1dc610fc2f8b503c96e4123076a5ee06e3064c8e17c65bd81a511ff7b346c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ad75ae57f25feccfbbc7a43d1bdebb2a1b22528b9afb384cc288d19fe3c6d7f4"
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