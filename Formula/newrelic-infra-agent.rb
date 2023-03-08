class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.38.0",
      revision: "5f1d8b89949237f24469b5d46f4dbb4f34ea7ac7"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0537d654a0b16d48903254f9dbbe1469c5f7745c5a0b7cf5f901ce64d9a6f48a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbf0559ca1475613f26cc5214a48d137945035851e0b16b06927fd20d9fb4c88"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "85c11029a686f5f6c41f2a2906eb638088485da824f02666995bc82d8939b59a"
    sha256 cellar: :any_skip_relocation, ventura:        "29a3383caee2630bf56396c07a4c151faa72acc701dede37ddb022ca134a31e6"
    sha256 cellar: :any_skip_relocation, monterey:       "5774b8562147b2ec975cfca77110e10ede9700005d2eff77afc7d0a8cbbd3345"
    sha256 cellar: :any_skip_relocation, big_sur:        "68ea1789ea3e1674f180ac08978aa3a086b2056ce60f1f795878891a4bb286bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2f5858f7d04a334e73c85a8cf75702aff18f245aac50bcbaad5c5a9ef22b35c"
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
    run [bin/"newrelic-infra-service", "-config", etc/"newrelic-infra/newrelic-infra.yml"]
    log_path var/"log/newrelic-infra/newrelic-infra.log"
    error_log_path var/"log/newrelic-infra/newrelic-infra.stderr.log"
  end

  test do
    output = shell_output("#{bin}/newrelic-infra -validate")
    assert_match "config validation", output
  end
end