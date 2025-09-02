class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.67.3",
      revision: "4a69e25bc47f2b33e5e64659b5f18d266d10fb6a"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88622cb2c375ac91486b33580d0567ed35998f6c59731b76b71b673a84fc9ec0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32e4a117bc057b4b3e912449dfa9beb76893fe867bf268ec6f3a3e896eb2425f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "18d86c7bc1e69668e5fd6e136f03edbfe0ee10298b2ae61c97b0361b50d90641"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4746455dbd2b12fa7d39ff1dcb5b4fbda4d020bce05e3c197412a70a6ab4145"
    sha256 cellar: :any_skip_relocation, ventura:       "52e018e2585d589c36c3fed323a870f605f80013d3fe80031f7d61e3a87d412f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ad0fc97699cb1a6bb0040fd196f0dab0a51e4b1be45ee7e976b37f0287095dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00981ce1db3e8271e72f16480497f94d599bebc09e5283d6306b9109042bd5f6"
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