class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.72.7",
      revision: "e95ae956e68aa6d938997dfe41feb091326c82a7"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a08f206fc576c1ed8b88b82902b6f99c7d92765ac56f01d0f64f6d8597a5a8f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "128eca6e42dd26109614958d45121f9b2bcad8be29fb0de02478628d6e80980d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b5cac1346cf1ab832fc1bde3c7766d9add838dae6d150d12c5d3b915bf9841c"
    sha256 cellar: :any_skip_relocation, sonoma:        "14bbe292474609a4ff82a82b17de5c1bf609227f4cadc25612bfec8925607fbe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a47c56e2f9e1268f5a309677f545381973c35c2f31f8da213bde62d82931d990"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f054116b254c8301342a006d7b5065a63fa70a560c12abcd28639bd1975fbe0a"
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