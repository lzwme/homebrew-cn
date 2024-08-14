class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https:github.comnewrelicinfrastructure-agent"
  url "https:github.comnewrelicinfrastructure-agent.git",
      tag:      "1.56.0",
      revision: "723f535cf74e150c7654d833a12d7c899ce627fa"
  license "Apache-2.0"
  head "https:github.comnewrelicinfrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a5cee7c74694b81b929d3bc2377696a3e7249ae23b1f0ff3fc1935841982c14e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41c949ab7d1c3fec732d55501b1abb39b0a5f1de59fdbca8a269b8a79e4a3740"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9dfa396ce08d36f252bba0ab2ef55c3477cba89ca3a95cef261edd0aa4931055"
    sha256 cellar: :any_skip_relocation, sonoma:         "df8da0512004e632d1eb86ac1c05bb8370db9e9e92dcc81e0a39ed64bfea5662"
    sha256 cellar: :any_skip_relocation, ventura:        "efdc0f27a8cff911b241f9aa240d2b9d3b457aa44d9605f9288bdbc62a4205b8"
    sha256 cellar: :any_skip_relocation, monterey:       "9e06fabee85f1015fe79a2a3e203c7f7742231e4c643cbdb7a7bd911dca357d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5fe10df3beba74f39abf1b7ceac7bcfb1909b3ba1d805a606c231b5fb1ad32e"
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