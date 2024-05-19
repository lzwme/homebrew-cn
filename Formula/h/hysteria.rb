class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https:hysteria.network"
  url "https:github.comapernethysteriaarchiverefstagsappv2.4.4.tar.gz"
  sha256 "bbfe5ae78a7c90ec3b5bff5af34accc73eb2daa7dd7cf5ac954768a2833f8d60"
  license "MIT"
  head "https:github.comapernethysteria.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3719a08cef21fe4fea8fdbd5fbc4249503bf846614a9a8cbecc641fa443fc0e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5f6a9ffd7d44c711558c96e1ff69a2edc3df3ff98be6e389588c725b054ff3c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d616e85d10861c28b86fa6f1e5fa3f42deaeb56644150aaa440ed31d3f258f73"
    sha256 cellar: :any_skip_relocation, sonoma:         "8505b7e303f440e7f9892091713a9bdd2be3e09df7a65b5963b34d0058189c0d"
    sha256 cellar: :any_skip_relocation, ventura:        "b807e785f5e7f06a5ff19fdea37049fc182c473d4561a9454bb500cea1e5ebdf"
    sha256 cellar: :any_skip_relocation, monterey:       "8a135de70cca62b8f75b5d61f47366c5e4a6fb1aa7137b70eca0e8d87b707dc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6bb4ef62e09ec123e18cc059603a537b1c13a2ed1348de5140031f23beddac6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comapernethysteriaappcmd.appVersion=v#{version}
      -X github.comapernethysteriaappcmd.appDate=#{time.iso8601}
      -X github.comapernethysteriaappcmd.appType=release
      -X github.comapernethysteriaappcmd.appCommit=#{tap.user}
      -X github.comapernethysteriaappcmd.appPlatform=#{OS.kernel_name.downcase}
      -X github.comapernethysteriaappcmd.appArch=#{Hardware::CPU.arch}
    ]
    system "go", "build", *std_go_args(ldflags:), ".app"

    generate_completions_from_executable(bin"hysteria", "completion")
  end

  service do
    run [opt_bin"hysteria", "--config", etc"hysteriaconfig.yaml"]
    run_type :immediate
    keep_alive true
  end

  test do
    port = free_port
    (testpath"config.yaml").write <<~EOS
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
    output = shell_output("#{bin}hysteria server --disable-update-check -c #{testpath}config.yaml 2>&1", 1)
    assert_match "maintenance	started background certificate maintenance", output

    assert_match version.to_s, shell_output("#{bin}hysteria version")
  end
end