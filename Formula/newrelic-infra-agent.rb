class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.40.0",
      revision: "5d29fddbb1dc7c9d05495623203bdbd5e58d2e7f"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8bfc50ace3896cbdd9bcdd27daa12c9bd38bf4c10fd5a3327914637d354fabc3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0dfe9ea4d640dde258022112c9b17cfb7d5a805fa798cb0f5f89e79f5a7f30a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b9bf4eaeccb2d4dc246bc37f709a09670095fbb45529f4f6e28677bd592264be"
    sha256 cellar: :any_skip_relocation, ventura:        "76512062e3c58fed6326155867f266ba8bc8a4e03b32830002d5b2af7dbe261a"
    sha256 cellar: :any_skip_relocation, monterey:       "8946b0dee70498e6f564ff70a1b24aa46dd3277e85e45c8292ce46fc90e9a425"
    sha256 cellar: :any_skip_relocation, big_sur:        "57bd49bae7f699fd1d5d84b3f7deca415261f1238796b059cbeb533d8b356dac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe8a419b9718f1841cc36d28edd63da3dcacfb2e033b48ea4e8c9f00244e6a8c"
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