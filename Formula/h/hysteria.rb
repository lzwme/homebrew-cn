class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https://hysteria.network/"
  url "https://ghproxy.com/https://github.com/apernet/hysteria/archive/refs/tags/app/v2.1.1.tar.gz"
  sha256 "a9ccbd7b38ccb9b8d0f3f75c18bd6846e32a58442dbdc2946629be4b3c5f6424"
  license "MIT"
  head "https://github.com/apernet/hysteria.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "03b9e2b11bdc8a765d7d3c68c6d2e5bd3273b2d702f249d35351f82c5938b93d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "efe22e3dc7a423eef1eb2eaf60b34e051632e95700d2bc423e5e5c772f8364e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2170def941186e2534401f3fcbf8d5733d5167056f34f168c1e1484dafa87b4"
    sha256 cellar: :any_skip_relocation, sonoma:         "e874c812a5517994bf002905ac8603ccf9b732671c03ef877c32bb8be3604efe"
    sha256 cellar: :any_skip_relocation, ventura:        "0535aadbf112e35fd6342572e745e2d92dede1956f593cc958b62c22ac5b2dfc"
    sha256 cellar: :any_skip_relocation, monterey:       "7815ed128d43274b0216adbb1d97523de2607a28cf204612b2dd4d53c5618aa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d3e623d9a253273d0584b43e68d5d83c278fca1f07f1d7d6b2dfbdd28d27afa"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/apernet/hysteria/app/cmd.appVersion=v#{version}
      -X github.com/apernet/hysteria/app/cmd.appDate=#{time.iso8601}
      -X github.com/apernet/hysteria/app/cmd.appType=release
      -X github.com/apernet/hysteria/app/cmd.appCommit=#{tap.user}
      -X github.com/apernet/hysteria/app/cmd.appPlatform=#{OS.kernel_name.downcase}
      -X github.com/apernet/hysteria/app/cmd.appArch=#{Hardware::CPU.arch}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./app"

    generate_completions_from_executable(bin/"hysteria", "completion")
  end

  service do
    run [opt_bin/"hysteria", "--config", etc/"hysteria/config.json"]
    run_type :immediate
    keep_alive true
  end

  test do
    port = free_port
    (testpath/"config.yaml").write <<~EOS
      listen: :#{port}
      acme:
        domains:
          - your.domain.com
        email: your@email.com

      obfs:
        type: salamander
        salamander:
          password: cry_me_a_r1ver
    EOS
    output = shell_output("#{bin}/hysteria server --disable-update-check -c #{testpath}/config.yaml 2>&1", 1)
    assert_match "maintenance	started background certificate maintenance", output

    assert_match version.to_s, shell_output("#{bin}/hysteria version")
  end
end