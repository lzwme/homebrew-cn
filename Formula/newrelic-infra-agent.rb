class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.39.1",
      revision: "5051b41d1fa18535e76f03943f24d254e089f223"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c57648dd2baf6e496f9e07fb8cb51ac87b227b91d23c0f2cf6db37a94fb7a7fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f435c8fc093d36d77906abe20e1bfb02bd5a9f7493f09f0e7d8df358de3ffeda"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d910831d5da166f7bd9be7c73c508cb98732e0a21ad791661aac81614697d68e"
    sha256 cellar: :any_skip_relocation, ventura:        "400d4c07a2566a5085128c9c312917e0a1f5842bdfeca40d6e5cd80bc9955a91"
    sha256 cellar: :any_skip_relocation, monterey:       "6145e60d2bb4c974bafe1fe85296247ce37b11f68e3710a72a4a907dff4a7057"
    sha256 cellar: :any_skip_relocation, big_sur:        "c6c048ed99349dedfa76f2e6324c9b72696815be1da39abb9421e2e667a6aa45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6dca7fd1b53555b1029679a1ea63149b7a978159e7a90be2c44f97f1ebe64c13"
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