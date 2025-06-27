class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https:github.comnewrelicinfrastructure-agent"
  url "https:github.comnewrelicinfrastructure-agent.git",
      tag:      "1.65.1",
      revision: "003aeeba6c6c80767dd23260e67fa399353bd779"
  license "Apache-2.0"
  head "https:github.comnewrelicinfrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "394c195e41f5dfbde04bbcb01ca7a7b7c7d803a36e65f69e05085bde67da9bdf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1399bec79d4c63382d3e0ecacb9e4066d05f9ecd9ba49527d170b44eb6ebcae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3e8d4de6e32d04d104ee6d2e48b9c354ab54dc878d10dfe0a023b0a23826c416"
    sha256 cellar: :any_skip_relocation, sonoma:        "333b8a7c6ac08750c09438ee7dc45c7870a7ea62b5bb8b4f9bc528032015eb39"
    sha256 cellar: :any_skip_relocation, ventura:       "758ffa0b2c6e1d8e99d28ae1fb4321edfbd5f36ae2c1e5661084fefac5a1588f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e6edf33387a032df313076b65cd28630bf853f451e0fca8fa62821b04642f1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6a575aebf3ed260050f83ebf57014d6742f1f1ea100570632e648522255ac00"
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