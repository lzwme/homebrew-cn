class Vuls < Formula
  desc "Agentless Vulnerability Scanner for Linux/FreeBSD"
  homepage "https://vuls.io/"
  url "https://ghfast.top/https://github.com/future-architect/vuls/archive/refs/tags/v0.39.1.tar.gz"
  sha256 "426f96ba4e85894f01c782ac72fa50975ee366d8ce0cff3166ed1c1ebddb61cd"
  license "GPL-3.0-only"
  head "https://github.com/future-architect/vuls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6baa16ba940f71bb12c8551a7376a6048a0a09291e3906aa863c9ae9e3dea108"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6baa16ba940f71bb12c8551a7376a6048a0a09291e3906aa863c9ae9e3dea108"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6baa16ba940f71bb12c8551a7376a6048a0a09291e3906aa863c9ae9e3dea108"
    sha256 cellar: :any_skip_relocation, sonoma:        "0266ec108c6df093411d5741f50d9bc3f5d1cc4dc9bd1589fb8bca683d38bacb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b08683ce2d2bb49ea8b47a4b7509938de04147bf5e245f2ddd89caaf7d13884"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ac79c23fa09e758baf8642e9ee1e42b4329b8bcf4b6f534d1f1520ab625b0ad"
  end

  depends_on "go" => :build

  def install
    ENV["GOEXPERIMENT"] = "jsonv2"

    ldflags = %W[
      -s -w
      -X github.com/future-architect/vuls/config.Version=#{version}
      -X github.com/future-architect/vuls/config.Revision=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"vuls"), "./cmd/vuls"
    system "go", "build", *std_go_args(ldflags:, output: bin/"vuls-scanner"), "./cmd/scanner"
    system "go", "build", *std_go_args(ldflags:, output: bin/"trivy-to-vuls"), "./contrib/trivy/cmd"
    system "go", "build", *std_go_args(ldflags:, output: bin/"future-vuls"), "./contrib/future-vuls/cmd"
    system "go", "build", *std_go_args(ldflags:, output: bin/"snmp2cpe"), "./contrib/snmp2cpe/cmd"
  end

  test do
    # https://vuls.io/docs/en/config.toml.html
    (testpath/"config.toml").write <<~TOML
      [default]
      logLevel = "info"

      [servers]
      [servers.127-0-0-1]
      host = "127.0.0.1"
    TOML

    %w[vuls vuls-scanner].each do |cmd|
      assert_match "Failed to configtest", shell_output("#{bin}/#{cmd} configtest 2>&1", 1)
    end

    %w[trivy-to-vuls future-vuls snmp2cpe].each do |cmd|
      assert_match version.to_s, shell_output("#{bin}/#{cmd} version")
    end
  end
end