class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.72.9",
      revision: "907b5f7942bbb146f0eab03670e3388b6bddaba5"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bfe3074b75651e440df7ac764cb072b3dbb73e011d03f7c443e0de26dbb26bfd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "828862c11cce5645de8253be8d8a5cc04090efb7438f77aec123c7e55a648563"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbe05cbb55f2f16638759bd383562afcae7843c532a1e7ad635da5c5482a4210"
    sha256 cellar: :any_skip_relocation, sonoma:        "4674ce44de12f3cce3e3973db5815fd0a35458ddc5d23ad92ee109509fd7f0e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48c3e88d0cfa09ca02d050a413b734a1ebd59a9ef1d0155cab00eb47e1befdd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aafb991f46168f9b76d2cc93664324800031a99c4df7fe469ec981ce28aca30e"
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