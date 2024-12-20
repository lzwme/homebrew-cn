class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https:github.comnewrelicinfrastructure-agent"
  url "https:github.comnewrelicinfrastructure-agent.git",
      tag:      "1.59.0",
      revision: "03003e6b1e38c123d091d538266380d60fedcf06"
  license "Apache-2.0"
  head "https:github.comnewrelicinfrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "186c68e747fc731dd79659f079b4dcd6089cb207a3c961b66542007ed14abd97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90e4dbc835494f1056cc65f9942b573ee5c048cae6aae8bf78b1630f8a2ab8f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5dc62e30c0c0ad34c6b0bc448b0246285371a205e612c7981e017512ba949b93"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb957923d7f64a519eb8403759e240e49934d9c0e331d9f7e4bc00f7c7fd641f"
    sha256 cellar: :any_skip_relocation, ventura:       "0155c14d5421a37760d41ac988a4cdb68cbd49c62f29482ee4adc438209894cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bdd53d5e95aa8179e547de25ddb78ecdd92834d9122f7c2b7dd2d85f6f5dddf"
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