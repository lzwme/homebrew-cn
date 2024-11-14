class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https:github.comnewrelicinfrastructure-agent"
  url "https:github.comnewrelicinfrastructure-agent.git",
      tag:      "1.58.0",
      revision: "1a19023b867cc2aac94959aa1bb82e3b53cb4d48"
  license "Apache-2.0"
  head "https:github.comnewrelicinfrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06ad247cbdb1434f8895a86dac1c84f02148aff9afa03bedb6ca730f74cec5c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca4caa081315ae87dcb87cdad748e50c81ad177843f08d9726eb3b0556cb0ce6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9171ed0d2a1b2c6e486205153b1a172af81a76179cd67ec6dec5feab78fbfde1"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d3036fc390e14aee9bd425633924306e34556300e550dafdbeff96ba08a3dd4"
    sha256 cellar: :any_skip_relocation, ventura:       "4c6f784174a620ff156aa4ab127fe663bdae011f64a69e8ca2344d5229a23039"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65bfeb3ec57220dd6a5af3b52e20477090dab74257e91bc399fe2636c5843e4a"
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