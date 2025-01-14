class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https:github.comnewrelicinfrastructure-agent"
  url "https:github.comnewrelicinfrastructure-agent.git",
      tag:      "1.59.2",
      revision: "32575790af35fe1d07b945fb56cd4dfb0c86bced"
  license "Apache-2.0"
  head "https:github.comnewrelicinfrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f99109e6f302d2fc1eafbbc89fc12984457a93b87423179dfd57c25c35de12fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e95a5ca523bfe48abb1534896e5513b177fe7a8999e0784d1c7f9ab94f83bf68"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1e50ef765bd5821accc924fcf568546f8deb011ab36169a1edfdec8849a626f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "287fdf86ca12ea5b10d31e0b9d7bbecac2c340885b875356b9acb95289a7dc90"
    sha256 cellar: :any_skip_relocation, ventura:       "6da59779b32fbe060dd1a7b8ee31125458dc401bc77a8f30d8d629c1d4562a14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1486da111c78da37cd7d30e5c4ba5226a3dc41c50775e60884742c954c0cf100"
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
    bin.install "dist#{os}-newrelic-infra_#{os}_#{goarch}newrelic-infra"
    bin.install "dist#{os}-newrelic-infra-ctl_#{os}_#{goarch}newrelic-infra-ctl"
    bin.install "dist#{os}-newrelic-infra-service_#{os}_#{goarch}newrelic-infra-service"
    (var"dbnewrelic-infra").install "assetslicenceLICENSE.macos.txt" if OS.mac?
  end

  def post_install
    (etc"newrelic-infra").mkpath
    (var"lognewrelic-infra").mkpath
  end

  service do
    run [opt_bin"newrelic-infra-service", "-config", etc"newrelic-infranewrelic-infra.yml"]
    log_path var"lognewrelic-infranewrelic-infra.log"
    error_log_path var"lognewrelic-infranewrelic-infra.stderr.log"
  end

  test do
    output = shell_output("#{bin}newrelic-infra -validate")
    assert_match "config validation", output
  end
end