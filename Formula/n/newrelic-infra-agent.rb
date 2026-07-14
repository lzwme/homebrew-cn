class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.78.0",
      revision: "15a04fa6498ba3ef1c966c3f5b0459e85b35e371"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8125d9854c47a58dd90211d0355c4bd2be40f3ab703ff934d1c91d764962af16"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "535b5ad54b0a307f04cf8b8ebf71c19322b423a48ae3dd056eca6749ed4f1a49"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a57a5a70a53732c5ad4e11bd92b0b8797260f1b762c326a31057a8fe387776b"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e5b5db33b55cd14d08d820500b69273153132a3420866daa7b3112cbcc19eaa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b15e9e94bf20496722d4cfdb25d8e3bbed0e021f09b5b6c0ac7bcf557e34674b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28d12c8d48a1d06598e55d2ebdf696a38e6109be7e799d5817ba831698846562"
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