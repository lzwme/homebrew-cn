class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.80.3",
      revision: "cba5a9988b484da06e150e8369c014bb21f2fc56"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "772b1044f324ebab2c5ce953a1f78da503014b420813b888a7d04ed5859176be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5af89a70573402f8a205fa99cf11651c9f114f769c72bd90a9a666625b305540"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8deb9b021f153e57228894d4c9f9b06ad805e1ad07a7a867ee8ceabf0591786e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "49bda38108a821655a34b14645ad93616efc77dabeb30b3ee181b85a2c95e6cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d28fab28f9937104b82afe3a4b7cf07ab3c76379808e417620156b07a5c6cc25"
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