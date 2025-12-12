class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.71.3",
      revision: "cea9e5dbb67783b2d1401aaf8dc1ee773809b30b"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7411eb4de33c0cf2b62a6c7e29ca9fc52f5b7d972c732bb682de2816fbbc2ac9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ede6e39679053e2bc146d4b0bc1cdf785a8ab6f25554fdca593125f799c6466"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72190eda3c09af0dfeadd3dc46a08b0897f0ecd1c61c3145f0520e3f32fc87e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd60679297d64c8761b0ab68e6e7cb476f9c67455a1e18578c34678387ae8735"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d2441df3e68de3c86e1c0eb518e9e0afee980094f5fb4ba7349cc876c898ed3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e33798a7565fc8c0122c79037c61d7feaf25bc6a4779963af6ad426cc3b756f"
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