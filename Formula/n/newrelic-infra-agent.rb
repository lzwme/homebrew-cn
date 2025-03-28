class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https:github.comnewrelicinfrastructure-agent"
  url "https:github.comnewrelicinfrastructure-agent.git",
      tag:      "1.63.0",
      revision: "c82224577ad3109202227f7ca63f68a5060d6cd9"
  license "Apache-2.0"
  head "https:github.comnewrelicinfrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4ecffaa16b6d3ef5670bd32a64ebdc22d701307ea4d8e57c476af656349eac7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed30c0fea568db5c37ee2ede4677a7794687b27c99a5b816dfd7a27454e842f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2e232e2cc58ac7b797f02f13560369de52fa955be05608f9fdb5ada9d84c8277"
    sha256 cellar: :any_skip_relocation, sonoma:        "9813a5d3fb5b7f3b4679731bc5cde88011449543b9e9085f6c39ac24d4bd045f"
    sha256 cellar: :any_skip_relocation, ventura:       "17dc5b11e8a469454345e7df9ee67746ac56117d6b8351d1ff3e10e182b86bac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c97b17998804b458cd6ca992db9dd0b21713f885e01ed4dcf40d565b3dda5d9"
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