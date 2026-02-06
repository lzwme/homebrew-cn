class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.72.2",
      revision: "12505e3c0d5688ba592e3b12f34e3c17905eedcf"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c33e6cd16e6227f34ac8f46334bb7c5d370322adad6bacb15e98568c58569bb4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c031493cee4150ec7ccb0ce8c80eb9fca08d170018e2106eb494e3e04a7d042"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed3cf3974fa45c1828fd296c4b265132fb306b36637f06d694e758bddf38f323"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d49fa9faec4cc2417dc685eb1520971d3637617206d1d63fb4db26ffcad5e47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e6aa0346dbb550ed4435eefec25eb4d748ab491d6a6bae3b1edd2e76460c462"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e77c4f05da009419ca2602a9498a09efde7cffeb32de2e6411a6e7d8cbb8d76c"
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