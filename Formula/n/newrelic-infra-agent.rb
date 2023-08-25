class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.46.0",
      revision: "ac47a7224fb7edbb64b500f1136785f4835638cc"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c06e91d8390515c056f243b3cf795be10d82f14b479a796808902a5d1bb56e7e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a30c00ed3b9e592779a44a573a91eb9351879c1eee3697ff153b87a266abe6fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1fc04999ee4d6457d3a5c19f86f627dbcce3bd2e7edef0b081bdf54424e46a29"
    sha256 cellar: :any_skip_relocation, ventura:        "518ac9d0b19eb2f022b297420280ebf73050914fbcc7e40ce00e8dca27593e8c"
    sha256 cellar: :any_skip_relocation, monterey:       "b75753b457fc478a3da6a37902d602f409c6f6da86112437aa7888c3771c6539"
    sha256 cellar: :any_skip_relocation, big_sur:        "fffca69554b7b54edae1af1e309e574e9d4e704f9935a721f91594f243238b6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d9f0b3c62df5c21aa8b228d3dede960c077465cc6cb851d0446c34be52aaadd"
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