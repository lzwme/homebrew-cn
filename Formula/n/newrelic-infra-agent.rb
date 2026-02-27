class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.72.6",
      revision: "14a2d2e0f2753da2154788a5615176651e67231d"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f688181c1136881d73a829dd2d78e693402fce0b6ad93ba74609d6bee6d78e4a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85332a3784dcbdf79f89ed41e0d45e8c8320666418e48951ac891c7fc3393a6e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ef53a78f9f145f819fe49afec8e15d4b4a5d9082ffa6c02c2f4a19baac8ccd3"
    sha256 cellar: :any_skip_relocation, sonoma:        "564fedae53503a24e3caf98508b2572cbc317f6c691e119020733392dbdba586"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a6fefc2db36526eee51106b72d3a6cca5926eb9612d7ba5c1e408ba1b6f8daa6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b14d541528097b4aba4e5585a4c50d08319409c6f806ad03050fa7435a88c5ac"
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