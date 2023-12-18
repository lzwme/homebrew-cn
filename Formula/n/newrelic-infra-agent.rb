class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https:github.comnewrelicinfrastructure-agent"
  url "https:github.comnewrelicinfrastructure-agent.git",
      tag:      "1.48.1",
      revision: "1242f680d6b12932f6dbf80994d4ef7980866e71"
  license "Apache-2.0"
  head "https:github.comnewrelicinfrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ccafd957b1a08e9b02e7894acf0d060ce42e4afa88767d5a99452c603eff5d1b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9fb7da3f7e79287916f378a80f1fa1236003b06bd998e09bcf57f599574f4dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5bcf763e6970a6a89edfea01e5234d86b5333b56767bbc3c759038904ccbfd3"
    sha256 cellar: :any_skip_relocation, sonoma:         "441dde40a2af615bf5306bc07d3523bf99aa2a35203eb1ea7da8f94ab6d90f66"
    sha256 cellar: :any_skip_relocation, ventura:        "bf9992aa8615a7ae4e7d2a19656f3f115bf6598712d39bce703ab017b4f0c1fb"
    sha256 cellar: :any_skip_relocation, monterey:       "fa0ed55d5e056404e51d895535af70a9b79b80be9672bc1d74f8c71bf05a46cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef0d190f194f14f67647dad5b8c07bf06187a7d977c3f169ea22fe3f554c02c5"
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