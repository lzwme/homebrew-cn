class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https:github.comnewrelicinfrastructure-agent"
  url "https:github.comnewrelicinfrastructure-agent.git",
      tag:      "1.48.3",
      revision: "b643a1b4c6ae89aba13cc594835a3f6ba9b7760d"
  license "Apache-2.0"
  head "https:github.comnewrelicinfrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9a46ff75a22f2a2a81b6deb13e85df594689d77734e08e6f76ef8eaf246dee7f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f28c28b633a6f025829bed9519dde6426a53ed64660198b9a2c8f037f3f1a6a2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb2fb515ef5b2aa5ee0a4dab898778cf9fc4bdb40d31f2157300b2debf782646"
    sha256 cellar: :any_skip_relocation, sonoma:         "0f403dd7ce97318feae34d6357d68e5c341e9d46850ee969bbe010e42ac40b95"
    sha256 cellar: :any_skip_relocation, ventura:        "263cefe36bf8690bd76ae94910b1451da6a0f45aaec54101f5322f60d4588cf5"
    sha256 cellar: :any_skip_relocation, monterey:       "02295bd5b16691fe48226458361546bb050b775374ec1246d41c8dc664e9c0cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "35f6c11f83ab58666cd9ad22e1e773df9666876d15c3609970abc5fb046e54e1"
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
    bin.install "dist#{os}-newrelic-infra_#{os}_#{goarch}newrelic-infra"
    bin.install "dist#{os}-newrelic-infra-ctl_#{os}_#{goarch}newrelic-infra-ctl"
    bin.install "dist#{os}-newrelic-infra-service_#{os}_#{goarch}newrelic-infra-service"
    (var"dbnewrelic-infra").install "assetslicenceLICENSE.macos.txt" if OS.mac?
  end

  def post_install
    (etc"newrelic-infra").mkpath
    (var"lognewrelic-infra").mkpath
  end

  service do
    run [opt_bin"newrelic-infra-service", "-config", etc"newrelic-infranewrelic-infra.yml"]
    log_path var"lognewrelic-infranewrelic-infra.log"
    error_log_path var"lognewrelic-infranewrelic-infra.stderr.log"
  end

  test do
    output = shell_output("#{bin}newrelic-infra -validate")
    assert_match "config validation", output
  end
end