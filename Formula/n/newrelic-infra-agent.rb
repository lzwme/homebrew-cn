class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.65.4",
      revision: "647262a48d6df9b20f7d0df14302247044b930ea"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aca6ab334996acf8dbd1fb883d110c82e30e570befa75cc4c649d7022f70bba9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1edb5bf2e769eba62d2dd6cad7b02e9c6e6e6b19d9356f59ae3281cc0e3194e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c2a5d85df1318b43b410445a45d1c70b5d8ead9e851b7d76f370c44b5c3fe81d"
    sha256 cellar: :any_skip_relocation, sonoma:        "bfecd0b15b5fe2086b81e7eb0811b61da4c0a11405ad4888671cafbf364772f2"
    sha256 cellar: :any_skip_relocation, ventura:       "7d60689fac19c76581f16562b0f9a74098f5a6b3d8108f42f4b69a1d8cc77db6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0d18d37ba1fd9d17a9fbb28923e44d3ec15e044702c8317d62a20955dca787f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3ff6b59a327a1c3c826834cc17d617982bb04a0d86f64574567ac3b2bfc3544"
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