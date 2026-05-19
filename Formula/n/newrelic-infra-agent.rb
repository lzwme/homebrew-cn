class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.75.0",
      revision: "46257660966eb65e10450db316dbb9cf222d97c2"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "71687bd37d10d76356c4a63f792784b53ac495d09c2613e42000c642a9b5c141"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad3c2143ace1394f374d64a8a7fa6671022a68fb0de559ea56df225cc76e574d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07e0a00cf26f30c3c2d7d8ba0abd33811947fd230c1fb1f37da07fc1120080f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "51b95f14363917420adabe5dc509cf5710573c839416825e4c82dc2a7105d17c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ae239d2c9f055caab8f576a046b10c17c97c859d341a0abbe0ac3bb44a632a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "412fd62ef23d6f80b779635c7b0abb7add971e117c3d1711337d0cbec695a528"
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