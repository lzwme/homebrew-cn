class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.80.1",
      revision: "0c3b140bc55f99ca70ec5967c766ac3a9210d87c"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53a0b388c0bf0f9031e2e039283722443d38038e6ce9dbc53509c31146a6a3e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6b4606ae2905e008bbe02bb458111c7f48e9020e6f560a83f8cc464436ae5fee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "148256b42d4682d2b44bf63d9213b50a5603e1ba5ed8e3eaaedc09f8934727b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8a7fde99b11fc5cfacd909687d73f448ed37ccf4ca4faba41b3486ed2458f51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "990e07510f650ddee5f0192b5e1056f149ba36d9ffe5368a3489498506afd64a"
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