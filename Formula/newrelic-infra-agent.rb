class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.42.3",
      revision: "c6a9b8e66355dfca048e78fc3b981a099ed2543f"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "616c1d9ba726edad9a19dd022dccd1d7d068c4c81b76d04776a8e2d0f3568705"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73f342b2649cd53c48b9840e0ba04277d57a45d443b2d8dfc51709c77a787f8a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "92a21bf25496fb750d80f5f6acc8cc4094605a186566fd1f61f4dc3a7574b115"
    sha256 cellar: :any_skip_relocation, ventura:        "3264bfe7fc268ab388cee2dfa2685bf6ed793b4ce2d5a01e6849fb9511385101"
    sha256 cellar: :any_skip_relocation, monterey:       "a41069c13a65bc1e1fa91261577371ebd56bbb08438a2c0f042187d4119fd936"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f13722fa86037efc6d25fb1142712dc2c55200deccf1dc49ed2540278d88039"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41c5ae30ece1891e4fdf8a8f62f48963a5c31c459fc5e079def8a0099d4e537a"
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