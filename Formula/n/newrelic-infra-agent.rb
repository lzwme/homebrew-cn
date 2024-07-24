class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https:github.comnewrelicinfrastructure-agent"
  url "https:github.comnewrelicinfrastructure-agent.git",
      tag:      "1.55.1",
      revision: "155c57d5cc9aab6c033cc9a60e95e8b4a7a513cc"
  license "Apache-2.0"
  head "https:github.comnewrelicinfrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "84a5571cf68df19738883a3201cf5d7d1cacca9148e3a683a8637e7139c589db"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97f421fc6973d464224708c5cffbc9e498b76305b5ae14a62afce9a1617b4891"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8aed75961e84b1df933dc657fa45558f02983b0d11e660c66fb39532823662d8"
    sha256 cellar: :any_skip_relocation, sonoma:         "32732d82d79fe6bd134338e71fb9aa0cae1d4fc67ad4a021ec9b35c54c6f1408"
    sha256 cellar: :any_skip_relocation, ventura:        "b9b47657e4ee4e3717bcebdf45419dbd7c9fa0caa63b313a7ac5dd11425ef601"
    sha256 cellar: :any_skip_relocation, monterey:       "6d468b8e609bc9cce2824f2bfe1750b27dd363edada9ecb50278b33346f3e7f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22abb88be0e0adeed398f6833ca5163c90790b7499dc5825f02571a846c49d30"
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