class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.43.2",
      revision: "4778a9187654402c775b677dcf4af28e3e3d7dad"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6588a6e34c3d68818d88ef8f5f59add0dcfa9955de8b9dbcf6645ea98f46c83"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2351e9377b0ae43b3b0c62965f098e2ed781f49766d70c692459bec1590ee1e0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "65689466173e7a58d90b060135ef270dfb8075d5195de3efb01222d7d4172c68"
    sha256 cellar: :any_skip_relocation, ventura:        "39e0547938658f6456c4a5c30bbcf52deddbde145337db02029dd8f72ae82c66"
    sha256 cellar: :any_skip_relocation, monterey:       "743293bdd5146a2af95efe98702114d09c8837abd9c0e5cc06d6268bb2b42eb5"
    sha256 cellar: :any_skip_relocation, big_sur:        "403b50e33d8a51250e06a42605321c83bbab159de9b33b216fe096709e839c1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99b34f5fbe280469a3a4d76a5bc3de157da0df8a653dd6abeacc718a5f82244d"
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