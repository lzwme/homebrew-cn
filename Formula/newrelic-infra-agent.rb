class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.42.1",
      revision: "128c8560ce0d6c45b906e351d5ae157850eaaf2a"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e7994e090c51ff25838492023c46356d651f8a6cfee4168face1afa7f7eab93"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79adda98f9ce69f7debd68d23cb3d80ed97e5e5fad2b40b86ae4bb689c7a830f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a1c53074b07295042ff6e8cbda996ae2073881c4f99637d98fd47c8fe500987b"
    sha256 cellar: :any_skip_relocation, ventura:        "27efa346d0486a2dec4645999a5819e9197bf74c12104ffa120851fc215d9ee1"
    sha256 cellar: :any_skip_relocation, monterey:       "aa8e5b999af7a13ccb5975ab1339dfe3ab48e216fc0a5f591ca10d2edb8c794d"
    sha256 cellar: :any_skip_relocation, big_sur:        "6143841155172c6f7090a308d75de5d8a3fb999125c0630dfe710cc2ef85303e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b6150dc2ef88f9d84744ea1c6e5af82fa61835c52b72b09ad580d9fa56431f4"
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