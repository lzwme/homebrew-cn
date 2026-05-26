class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.76.0",
      revision: "f411fda35b1c09bc6fbf3428b57896b15b7ed413"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "298a7b0033602caf972049352878086f4f2e8d4256add526116574482d843883"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9d55eff1bc90597d795b74537fe187b1f7326f1ee6b2aee9e5bc151f0d06586"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "561d29814ced35e855f370e36e7c9c3cc2f0bc5d43ffc41634823b0782479c39"
    sha256 cellar: :any_skip_relocation, sonoma:        "60e097400ac0697402b7a366dc811bd02aa7d86fbe2fc09aa338c4f1c30822e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a14312803259f0bd9c4e53f8d7a3382a556b85da80f7175443ea4c51f16aa144"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "600caa71514b50035b38e6d228a07af0077be567cde98ba8e9e7df04cb407736"
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