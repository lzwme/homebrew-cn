class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.71.1",
      revision: "d252cea32d3671d8677ad2a13908183a973549b4"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57d5423eb4b27bf2d426775b5e914402143a3781e37f3afecedf2ea5d3bbae53"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3720c718dfdf4a79735d78790ddfe5c6a68aad53eae42468a26f185719e08a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6ea14db9a07aac736c13f2a6c4c509c9e6386e7b35bb4eae8f80b917f22eca9"
    sha256 cellar: :any_skip_relocation, sonoma:        "f03c80556c1b7215da554719b36917d4c1b4e7cbf98f6ca0c0c29e451b88d11b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "baeac8d94393e15910a51ca677e78255322a7554b83b3f3b31c3be6626952b20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1ce522ac63da35e3974f579230b0a05f71169fca22e30580fe817ee4b243c83"
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