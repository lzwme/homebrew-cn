class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https:github.comnewrelicinfrastructure-agent"
  url "https:github.comnewrelicinfrastructure-agent.git",
      tag:      "1.60.0",
      revision: "346707f248c1816caafa5c14f13571846d130dd3"
  license "Apache-2.0"
  head "https:github.comnewrelicinfrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd5afc20f0224b35dd2d7aefce850653771bc3bae6130ad99c9dda38d579d373"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a26a04cf6d48b42021c31dce1eb7602a1f3b907c90c00e4717501a016f3d198"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f82ae3ba2ac1d356c29855810b82d7a44be46d227f7e61cef3b44aebe18904b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "160ee1e9d9448dd425c5b52368e6d806eb694ea73c364e60627b6e940f00f314"
    sha256 cellar: :any_skip_relocation, ventura:       "f175922dce4194ceeb9648eb74985994ee83a1a2ecf8248e332696eaa99abe9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d32b41715bcd0ab7454932dbd3aa471378107201360d038a894437dcacacb486"
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