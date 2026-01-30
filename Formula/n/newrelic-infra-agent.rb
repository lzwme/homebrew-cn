class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.72.1",
      revision: "ab4ca398712d148a035d43171415d0e92f846d3d"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42b2911262083e8788ca3ee0e9af16383d114c63fc1adf4c8519ac43f8fd31ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a93716d6cc4df7cdeb627444df10e5e3bd17a387eef73c6d0fe3b10a2742c52b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c77a5df86176aefcf6520de7f533c37a4d47d9754b9928530531a21db7456853"
    sha256 cellar: :any_skip_relocation, sonoma:        "7130aa38953ef21f59d06ea894a49fbbd963e64956cbe2ded32973e3a9fbf50d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79dc476164f12c80ed101e64e728a0d983a5673e19ed9a164e1069e62f7d36e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0180bac586ef024c799d7c81079304cfa182296f7337de11c880eac686c2a597"
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