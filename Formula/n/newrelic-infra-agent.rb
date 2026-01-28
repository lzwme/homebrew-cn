class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.72.0",
      revision: "31cd8c6e13ad6f7e2dc68ccc3987cfd50b0c1c6b"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aaafe72fdec0c9f97c98c6ac86e1d1cb378ed30ca1cd834b9ff742a24c9e151c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e84cfa72a09a3b812491bcf13ae3171bcf91c6d362d82a2a24769497b7cab9f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "775437a07daf79f1d38e71b6e62e0d2a641a7057fde93217c0b8fb47f400a3f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2de984e49d4ad46b3eec78012b81ccd80cde4a70af80fccfb2554cfbe13adbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "943b2ac8c296230aa4e0ca64ba464350a4bbe0966417a53619e927f50a389276"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3c74ff446f2e03199add3dc03564296254d58872d00298f2860a533a4d33aeb"
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