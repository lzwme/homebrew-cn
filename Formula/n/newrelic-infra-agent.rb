class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https:github.comnewrelicinfrastructure-agent"
  url "https:github.comnewrelicinfrastructure-agent.git",
      tag:      "1.57.1",
      revision: "367ee4b9234fe132bfe9454c5bf8f9c71d6feb32"
  license "Apache-2.0"
  head "https:github.comnewrelicinfrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74656be0f36fcdbe4ef7bf91ca411add564c05a5a33d672d5a59baf44280b3e8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1bcb94727657a605246ed3b4df3c7f94067023a55461f1bc64f9ac26e7c7572a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "75ee7c8b65d4ef40fc48da7f52c033f29f429ca4fe71429f665e66096ec6cffc"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba292cdd79704bc32c6dc4223ca2c09bd2cae47c876474a4e3475bd6f8dabdb9"
    sha256 cellar: :any_skip_relocation, ventura:       "89f8358aa399a14bb2ca6bdb6736b47a519dcba3bf5218329322fcce4a70beb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42c973cdae6e2554951350acb5ed44c2a5a9df8641be3b68b72537794daa87a2"
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