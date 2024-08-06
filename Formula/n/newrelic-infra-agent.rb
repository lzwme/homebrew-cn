class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https:github.comnewrelicinfrastructure-agent"
  url "https:github.comnewrelicinfrastructure-agent.git",
      tag:      "1.55.2",
      revision: "0745389cc67e496af663706ca5f6f19a7173d26b"
  license "Apache-2.0"
  head "https:github.comnewrelicinfrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a77677ba053817774a88a9dc5001682c2e6728b0eb38839dd58083a8859f8b54"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "daedf371bae0654f5a4c3c3923e355812b01da9072bbcc47f22b8e10accbb566"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93660e897449a8ccb3e574676e5b4271b9f013a4d4cabef2bfc95cb26cf3b145"
    sha256 cellar: :any_skip_relocation, sonoma:         "966ed6e9055cdf33e1ebf2259dfb15c72c8c61476c23cc80e0c495191be8f24f"
    sha256 cellar: :any_skip_relocation, ventura:        "48af08d06309390a3febd36c374656380d64962512cd00ee1ac2427d7a4c5be1"
    sha256 cellar: :any_skip_relocation, monterey:       "f8250d9ec13d4b56df76f6db33678373e933ccde107e5419c9daaa175b06589f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ea8ea0d2795f36526bc8104cde2ee75142d1ec6653bf0aecbb93ea08a89d202"
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