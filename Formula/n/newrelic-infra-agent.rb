class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.65.5",
      revision: "c225fb27ab5a6edc7200af18270e293a5a80f0fc"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e11888a72e364f96ef42b57ebe4b3375e7ff0729ad063a37f296e4b8c0a13988"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef47c6d561b25353e12a53b27e8f722b526a668d98aed4f27ec8220ed60cb33f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "82ba490e898091906af7f515dad805d9b06534a6e20fc57b41d5dc087ee811e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "13a4665794200c9c7ca94db86243279923b0e2df09e477105a609fb42afa78fd"
    sha256 cellar: :any_skip_relocation, ventura:       "b212586b372e8f927edca280c3b1ca270c7968bd10e6e6e976a8efed46bb6922"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "236f1a848df29f53ea9117dab1d31c7444a4df04f5bffae7a27402ca80a39808"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93c97dad26b682a06963687f60f09b6f67baaeff52491811ca6b49a8656e50e4"
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