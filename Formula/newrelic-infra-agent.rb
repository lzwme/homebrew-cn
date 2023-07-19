class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.44.0",
      revision: "e8840f1f444df272d7f8298912421eb51abdff80"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cffbe15ab3f2111901769dfa9aa562bc3a3ca3e6377123fb7a4aecbec159e590"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4523153e62685c414528a7531fc4f4e9002c6e8c5079efebd1516abc6aea1fb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5eb6aff2c37c1849ca3df61a3f9951b11a3ad37d0b358a8cc715aad6578a5ea6"
    sha256 cellar: :any_skip_relocation, ventura:        "48651c00196c3bd566f984416a88f2c158f53eeefe3f2f60481b6b775375752c"
    sha256 cellar: :any_skip_relocation, monterey:       "d1cf73844a04d24880f6cceed0ae3e8658b34af2d39ff760ece17d31d611624e"
    sha256 cellar: :any_skip_relocation, big_sur:        "634c190dcbc2c4d9a872af2f5297581da9bd0ba2d56d884af19897ce1b7d893c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fe68cee5be34cf0ac4ec58e946f7eb8aff29e6fbe3dc9bdc8902ddd641cfcc1"
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