class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.70.0",
      revision: "bc3c26b1c3482ad29a48edd8dc00cc98c5dc623f"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "243857c137e348269a268956e34b60a6feef45fce54edf0305c2175d7bf232f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "535abb2ddafddfebf09ab1a31d0bb17e1a843490374d88dbea3b517b43544334"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0352e07099017e58e998f5fa95e8b07c9bb0054c09bac33bdcb0ce0d36071377"
    sha256 cellar: :any_skip_relocation, sonoma:        "96f960ce44587b8a560a4863ee6fe988f5fbf4742b7e9f3adcd4b1fdf7c28ab2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "830ae90911a57207a3f04ad0eb6c313d17f87d40a622f7e9ecc6bb490c247239"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37840e8d7244b8f796f6ee0eb406bd466ed3cce06882f022cd87eae506a4c9fb"
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