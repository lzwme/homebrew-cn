class NewrelicInfraAgent < Formula
  desc "New Relic infrastructure agent"
  homepage "https://github.com/newrelic/infrastructure-agent"
  url "https://github.com/newrelic/infrastructure-agent.git",
      tag:      "1.76.2",
      revision: "0bca0cc8782bceffdb3ac2b60bc1c3418c9e5668"
  license "Apache-2.0"
  head "https://github.com/newrelic/infrastructure-agent.git", branch: "master"

  # Upstream sometimes creates a tag with a stable version format but marks it
  # as pre-release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13954dbb2e94ff28683d24ae59ed1f41e2c7c94c965653e0761e2606a21c8a8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5917f53a994536a709461e2c752e3a3d7986f6a1e8f5014a8a83d548596fa923"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f9ea3970da4a91a589fd81ec9973c5883694c26f9809b5eb6d40ef4c8e8f7cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7df8d23f258b020f4e9b9ebf8d9751611c87a3cf59dc32686f4df70642dea45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef8b293cf6f40c37d36081453ae9e1dacbfbd71b99a854e87abe2147c8550148"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c46a5af7a8c72ed8015a0d82daae222da53d17661d78cf918e63d68854efcd79"
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