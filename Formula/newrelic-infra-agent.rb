class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.39.2",
      revision: "226340691e6531917038d223f5f7e4f31640c9f8"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d467f806a08b03ad5319d116c676ed56c97a942df7528a20b01e27f8a6d58df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b07801ada876599058fe81c6ad4f7e5f083a9ce8c0f05d9414a94ad58da86d31"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5105ee09fd11a34f4d293795943fa3fb83d62fc7605351ec96447f0dcccc2d29"
    sha256 cellar: :any_skip_relocation, ventura:        "a6d160b67ee444db46afe7a1e5d553ff89c978655f652e91b68e4c714074c096"
    sha256 cellar: :any_skip_relocation, monterey:       "3e23be28372e458d937a9248bdb1f60630e811c6efd72de825ccb5d26350dc3e"
    sha256 cellar: :any_skip_relocation, big_sur:        "651a8356415381d2f12cc92c083b2c2444b81d46279a59b44b6ac5210cac4883"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a24c8e018a94c5e5eeeb6b1bad4083e6ea3bbbc9bdd7d379ab06481a0fbf52f"
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