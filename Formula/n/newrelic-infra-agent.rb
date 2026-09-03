class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.80.2",
      revision: "005e97f63bb515bad8feb83930c2b1165854280d"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f84c39d8f837e2c2e4c4e5934881add726065248a3b0e353d138c2b1be8c9cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "526d612525f365e2c8a4f58b3420702b0d9921a56e81376a42a6c488ba97a736"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "743bde26d2f0a6a4d10845fa22d46b2ba7a4db06379bd49805e9ad7af6373a4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11e858a80dd80278618e95913ba9ad83bd3a38a8f783ab1a55e0d1615d5195e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "117125ca6e107c83d65913d15a47c33aa19af7b78e5be71582276c830d7840bb"
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