class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.71.2",
      revision: "1b77853b67f9a5fbe0948bba1aaa69a7eb53df9f"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9e74ee44ec6c670b9e760f2ee907a2dcbe8e3e1eaeae6d20a4a4588e372ca7ca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f37f127d35a3d2dd999e141f08b8afdd3d0d109e51c6881df2ef52eaa327dab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a01f3cb83d6873dc397e1ef57b05609b77fc18121e19c349a7a5ee5ce9551fc9"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fe2d6ea944f34324aa41d117f91c622f4a4a02d5cb7a2f0c986f62ff4dbe871"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e0173101af699f2decb44281548476e8857c472c09dcf47940b2ef9e27ca980"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c70c7e094b3d9b448f299bdc4a1d174a3317e5d2be6c56a9ee35f800ab8ee845"
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