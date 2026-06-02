class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.76.1",
      revision: "a5b0074553476de41f9f71127908d0d8e3c6ab9b"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2eb4a6e926d89586a5fbaadd42a7cace77b755e8907f33c6bf3c668581f7027a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72363a97702cbb67b90ec9dc9706ec76e51f228baaeb8a578037086c9e56859b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "956342da7e0188a0a08c319491c37d35804f8b65f2e8a8f0c297d3fcad4a44e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac8d8bb6df1de437fbfa7e6ea1f5fdcf70b9704d90312e26a3142efcac840ea2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8774185306d10df472fb37905b276f9a9f5aa9e57a0efc94ce27595fc2a3524"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64d7649a6bb1d19b2951bbf26f64402886a88a578d849f991b70c2aece2c4ebc"
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