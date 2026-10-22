class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.80.6",
      revision: "3bdc56490f4e7b36cb0db6056e9b00ea8b6e6de6"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d7c4192d629511c343cf771b0a06481cd40335b4dff7f8b4496f89595eb7b915"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3a69cb734492b645dceede89a3969948b145f6bed9d091e3800bfe8c89a3aa94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a0d117d6cc82743ed83e25d6ea599807027dc533a78e399894acdca24d06e87e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9505ebdba3e3bf54eec019ffc57d027f338a26761384aedd5d94f422bdd4229e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "7efc44dd3235edc8484444040f3095e73df8d287df8c9dd7e180aa886e0363ae"
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