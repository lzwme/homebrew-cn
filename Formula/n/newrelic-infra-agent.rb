class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https:github.comnewrelicinfrastructure-agent"
  url "https:github.comnewrelicinfrastructure-agent.git",
      tag:      "1.59.1",
      revision: "6ca760d56f9fcf4598c9836f6aa1609e9bf28834"
  license "Apache-2.0"
  head "https:github.comnewrelicinfrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5324cebe37cd0d2de99069c4196368f3c77b982d767c07894161bcd3ec49afd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ecb8c282246d940277f55d8af08ceb3605acfdfee9b5f43da579d1f8488aafb6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1fa9df9abc3718d69257f6adf4dcac4288d89124abe2abd6cfdec853dbd1c8b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "791a0e3aca48c8b5ed7e15fdd0bceb91e8823fc29092505928d26aef459d8a2b"
    sha256 cellar: :any_skip_relocation, ventura:       "d2b0d18c37b607990816259c8efde7039d3f1fe285b9001027c42a52d3dffe7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ba222943c6eaabd632ba205a6fc553d220e0d8d5e41905abf164ed35e1860d5"
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