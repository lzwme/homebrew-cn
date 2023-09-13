class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https://hysteria.network/"
  url "https://ghproxy.com/https://github.com/apernet/hysteria/archive/refs/tags/app/v2.0.1.tar.gz"
  sha256 "5a181f84c1dc1b14680478e03efe11608e743b501b528c5cfa0771462ba1a350"
  license "MIT"
  head "https://github.com/apernet/hysteria.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e02fd7a77ef289f2e538783a30683f6c382bcc339f125f65c43ffc2f2d3de1a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "237b3cac17189021d0613354d06f6f763dabe0cce22e44c2dc3caba76868f36a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a8455a8ec7b388ba1a8aa0f45d099e8173bf248592e2ecaf3b2b2de83ea87cb"
    sha256 cellar: :any_skip_relocation, ventura:        "8d6b1b79c86438dcb6ad2cd930f65cb9acc4dc5326f83fa9d97eaf15a6b69a69"
    sha256 cellar: :any_skip_relocation, monterey:       "d97db70049c79037c887bd6df27725172fab8d8e61ac0b3246b90e1172817d5a"
    sha256 cellar: :any_skip_relocation, big_sur:        "791d6284eb16a920fc95e8cdf22832a5e6bf7d9290cdbe40f40f1d62b2bf2a3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc76b8a730b38231698a40987fb419785f8ffd4c77ae51399678c5d1abffef2b"
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