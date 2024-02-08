class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https:github.comnewrelicinfrastructure-agent"
  url "https:github.comnewrelicinfrastructure-agent.git",
      tag:      "1.48.5",
      revision: "dc028239b90177c9929c8014bb4c94e3e83e8663"
  license "Apache-2.0"
  head "https:github.comnewrelicinfrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "26f957d209e3a909ad22f0f9ff4a835f7cf0dad0fd061165306f113e2e42a7b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "267cd033e36c45865916c537b1a032b9184499e46786250dd4731aaad1033438"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1be215b112c09f04b16310535519d9182f58f41d0b4257deaba5bbc172e9c008"
    sha256 cellar: :any_skip_relocation, sonoma:         "5b5c02197f99744945b141c612da9c0f52256bacb02bb5b71da8e28139d26b4a"
    sha256 cellar: :any_skip_relocation, ventura:        "2b0b722b2a525fc0dd87a6b507d115d15017310748c629a407260fea61b62607"
    sha256 cellar: :any_skip_relocation, monterey:       "ec0cd8b8cbf06b1f2e61cf965299b6a8c68c803f89d3a26f03074fa3095bb77c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60c6031b0d81d5265cce47136b53ac49e06810dec3df92d9d944a0082714e2cf"
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