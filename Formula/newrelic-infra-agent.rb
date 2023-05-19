class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.42.0",
      revision: "3d62918942cb848b40cad06dcea2d86817fffec5"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6192a64d84294ca999d31be7bdfa9f7cdaedf1dbc117e9fecf2ae9eb7173029f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ec2e819228e7dfc641640edd8d11aaf878fb998d7ba584042730f0838f4f9f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c6348ec5a7f022eeea0888515217c88459346e30c925f3649334ce5dc96f009c"
    sha256 cellar: :any_skip_relocation, ventura:        "e6a2149b3ca4d26867b79d873fd812375206cab5c61609d802c2d415e47ecd6c"
    sha256 cellar: :any_skip_relocation, monterey:       "059b321dda0ba6bd185215f44886cc78c1d4d325e54b080aa33d90ade88bee6b"
    sha256 cellar: :any_skip_relocation, big_sur:        "19c665a5a0289f908bac3e0c6afe63b8aff0b64666f37c8556b263fb620e6b43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8aa8b2da271e30b377c100371fbdbef39532e702fc88cc92007ed951a4bb688"
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
  end

  def post_install
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