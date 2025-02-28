class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https:github.comnewrelicinfrastructure-agent"
  url "https:github.comnewrelicinfrastructure-agent.git",
      tag:      "1.62.0",
      revision: "defe0d3e795953c6761131ffe0e4e03505e3267d"
  license "Apache-2.0"
  head "https:github.comnewrelicinfrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72ab060219eb456d84601f86c65cef145cae0608c12482f236de24e0942d1c46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f4df8e48a8e6c528305c2061757782c28957c23768fec6b63fd22ad45ca43fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3e130f918667e34503891a304fc2d422b5e3eb6caf6ef4035b4451c40a7a8886"
    sha256 cellar: :any_skip_relocation, sonoma:        "a24aa96a28520ce77a1d8c157fadcb823e7e1411f30745cbd80528813a0ca625"
    sha256 cellar: :any_skip_relocation, ventura:       "4d88cca664e3ab095e0ab864e23fb6ca9a65bd6bf172da20ea2f97701d5b56f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ab51bd6f2c3265c9cbf7be6c2149d84d0531419ee8008103321e16df1fd2abb"
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