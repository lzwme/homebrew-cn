class Vuls < Formula
  desc "Agentless Vulnerability Scanner for Linux/FreeBSD"
  homepage "https://vuls.io/"
  url "https://ghfast.top/https://github.com/future-architect/vuls/archive/refs/tags/v0.38.5.tar.gz"
  sha256 "14ffabaff438ba48534af769c3c2e827278a95ca66d30a24c1701132712c73ce"
  license "GPL-3.0-only"
  head "https://github.com/future-architect/vuls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "697a0bdbc2d947ad3c2897f1e83c539e91b8f1e8fd9a1c2e3d9a87cc1f5ea4e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9284ed9c3b986e0fd5a2f540786f7b234a1a22747710a040344ce48faa5b0695"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68529ca23459f1dc0f873081d3cb148e533c8ed10efaaffdc6a453aa9b965790"
    sha256 cellar: :any_skip_relocation, sonoma:        "20bc9dd80767d3515baf71b7808511eb2abe88fe00a77ba73a3110b96c45dcfe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e27944785589bbb7cc45e12b025184aa40e70cbaeff22bc3a22dc4bbece65ad4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fa38c517cc85caf4e20bcaa0d3ea102a254a57ba8024901d48daab9c47b58e9"
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