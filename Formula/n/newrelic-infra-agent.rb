class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.72.3",
      revision: "0eeeec30502b6f33e44367b47f6600ae6180c131"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ae6201e1c3a7dcea9b0611956a1ce3683084da29698ea4849887130f709bb8d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "07ac8c1a0d26982e3d78b0c756ec9f29b685a11b42571cbf1697e2119741cc67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c40b688b1bcfbb947a99aeb075d72814a1f0cc688621bdf77547eab7488fae53"
    sha256 cellar: :any_skip_relocation, sonoma:        "547502c82b7135e2c40b24526551b92d83edbeff8f3dcc4675e81972273ff85b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3bb436c9f85fb984e11b85b9fb0a2d739832d06a5c51077c4a1e8011a73bc81b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc3c02bd66e0b5e39dc8fdeb04d41fa3f23b5c096af27c1c782820e5739c66c1"
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