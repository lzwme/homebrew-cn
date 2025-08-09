class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.66.1",
      revision: "429ade0368b50f3f7b3b7ea43b0b9d5695cde459"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d1fe2a7791d1603040c55d5d29b2a235cd4d77673087e48cd2129b3892b5355"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bf0d60fbf3a048ad6c04b6a6df27310b6234cf59f512c9c45cab3773d59408a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d8b0ce03ab43ee833caa25cfc3109f323fa578f58c8cb9c28d507a2471c4d99c"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b1bed8542b3e49fe781dd8f722a8f6bcf913022056ea5cb827405590b2dce79"
    sha256 cellar: :any_skip_relocation, ventura:       "c2b880523a9c098f2d07ef517e83e58c9f2aceb53e3260b6fe418369e0d4565e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f46626d225811cf3526aaf400c015c4ad13f36cabf8464b67213a9d8861ad372"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4026fdc23f9e855141ef2fd1b81cc0b51b756947d37877cf9b43437ee461467e"
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