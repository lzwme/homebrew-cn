class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https:github.comnewrelicinfrastructure-agent"
  url "https:github.comnewrelicinfrastructure-agent.git",
      tag:      "1.55.0",
      revision: "b506ae4126f3a00bcb6368a45bd45686e3e399bc"
  license "Apache-2.0"
  head "https:github.comnewrelicinfrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "53b277d8d6918acc22ee7eebde5a2752302ca1bcee44985f6359ed91f702f586"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0307021ff3a7b51d1939cc0978e90fc293f01dd859dc1aa31cb85c0967e5850c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff3c33ae6f92dcca9adafa59412e22ed5bd002474228bd99c337fa1256ebcce2"
    sha256 cellar: :any_skip_relocation, sonoma:         "5f01d9f0281b85fd291a5378ee8cb7f188e394e394e3e7bf6f673b06d1de3c6e"
    sha256 cellar: :any_skip_relocation, ventura:        "ea3698f4dce597f6a548e3fd1b332625544629020f8b2e8fd4b7876e5a7e00bf"
    sha256 cellar: :any_skip_relocation, monterey:       "42265a01f6c18d86cdb62a65315aa0e4aa9a8e8833bfc9ee4250e4365f489305"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "901fd7b4ac4e61aabe4a8c3c2f8224e620b338aced1bb20f8c6b4f83a9f1d610"
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