class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.71.0",
      revision: "a2ce32e5cf2869d3d1abff9e8e29640813e3c034"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f2c691c1123522b5429247e76cfd237ad409ccec144dd22bc1c300015693fb0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3625b9720d55ac174f12dd134f63b332e8362bd66e0858990dcc38d5cfac41c6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "630a48630f94a25082acdd913f677ce028c3f83eabc6873b82319a0b00446771"
    sha256 cellar: :any_skip_relocation, sonoma:        "892dcab0aee9de692e16244a0aa4913665ba4bdf3eb27102d8211d77be118766"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0836884a48643ac420a9c48beb45624767517719ec2be1d043fc74974eda3d07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "308a05a8a12d27c2de2b3c6586ecbc63350cb5aa6fd13d24d609bf93c58492a8"
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
    bin.install "dist/#{os}-newrelic-infra_#{os}_#{goarch}/newrelic-infra"
    bin.install "dist/#{os}-newrelic-infra-ctl_#{os}_#{goarch}/newrelic-infra-ctl"
    bin.install "dist/#{os}-newrelic-infra-service_#{os}_#{goarch}/newrelic-infra-service"
    (var/"db/newrelic-infra").install "assets/licence/LICENSE.macos.txt" if OS.mac?
  end

  def post_install
    (etc/"newrelic-infra").mkpath
    (var/"log/newrelic-infra").mkpath
  end

  service do
    run [opt_bin/"newrelic-infra-service", "-config", etc/"newrelic-infra/newrelic-infra.yml"]
    log_path var/"log/newrelic-infra/newrelic-infra.log"
    error_log_path var/"log/newrelic-infra/newrelic-infra.stderr.log"
  end

  test do
    output = shell_output("#{bin}/newrelic-infra -validate")
    assert_match "config validation", output
  end
end