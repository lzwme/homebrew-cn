class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https:github.comnewrelicinfrastructure-agent"
  url "https:github.comnewrelicinfrastructure-agent.git",
      tag:      "1.53.0",
      revision: "dc896c41ebea1cf7b15effb3cd05048e09a6bf70"
  license "Apache-2.0"
  head "https:github.comnewrelicinfrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8b260ef10c817b0eeb4d34e6dd7a23dbdf11b97c3510c0faadcc250f7d56f6df"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef290cbc40bc4adda714034b766caf26ed1ebea9e406daa1cdbeebbc6060dfcd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17ce89f8ff2ed09f682a46c1d076692242ac91dbd71d5abc21f6f33a2001c401"
    sha256 cellar: :any_skip_relocation, sonoma:         "3ce9c45599dfceee194a90e5fcfc8357710fdfe1ac641927e233b85e85851d45"
    sha256 cellar: :any_skip_relocation, ventura:        "003e9b5a0f33508edb1e4a89f8786eeb4a7ba207d739b0d52d087627872aeee7"
    sha256 cellar: :any_skip_relocation, monterey:       "44181084dff6d908fe652cb7e7e8e67c3b03ed296135de9c25c85545d10970f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02780daa1b13a68e3b9875a3c0223d48bdfb9cedff84bcf973edf76400e7108c"
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