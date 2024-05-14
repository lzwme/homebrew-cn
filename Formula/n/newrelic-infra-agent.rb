class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https:github.comnewrelicinfrastructure-agent"
  url "https:github.comnewrelicinfrastructure-agent.git",
      tag:      "1.52.2",
      revision: "dc280de6db94fbecccd2b29ad8cd879e00f343f4"
  license "Apache-2.0"
  head "https:github.comnewrelicinfrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cc595a730de0c79881b891faa53754500a85095a410a4c95e29411290cded8bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1d8050f09b98105b6f80ffe2dbe0dfcbd47b86efa9fafa16610be13db82a04bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da74ec1a89a29923ea61b59176d680b2e6020dae6dcdf2624d07b30f365b7300"
    sha256 cellar: :any_skip_relocation, sonoma:         "e18bc4bd98a29b924fcc3fffb89d4421a09b4b1277fb7ba941f0a17fc2b1af7b"
    sha256 cellar: :any_skip_relocation, ventura:        "8281827d5b64026f950e87fc5a648b0779b1026529bc6892f58d73caeb838581"
    sha256 cellar: :any_skip_relocation, monterey:       "f6b7b6ccccb02789f9b63c9e937e2fa3951d48ac069170b9806ac6a640491332"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28f486a32c2f65fa22e1e369b421e112e0e68d9ebe26e05d777333a251001b04"
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