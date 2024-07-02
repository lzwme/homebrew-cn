class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https:hysteria.network"
  url "https:github.comapernethysteriaarchiverefstagsappv2.5.0.tar.gz"
  sha256 "78afca9c9c3f2c1a89c2356c66e70489bba74d3b4ede42f4194d179a09959d8c"
  license "MIT"
  head "https:github.comapernethysteria.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0c647673a6bd199ea525057ade48070d1f01d16f953ac337ef0a55d76d185413"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad75984493b3b9a491b39d56c95a749eb58a3676aa2c5f5513a597d82322f851"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6841dbcc258e55304dcee33e501cf07ef6c47a5859a3c24735d495d313edcb42"
    sha256 cellar: :any_skip_relocation, sonoma:         "ad7eefbfc8003121e425dab68191ca78fcea809f09999b7b5893f732ec4ccd78"
    sha256 cellar: :any_skip_relocation, ventura:        "8c6753bad01bfff8cded6804e8cfaadbc96b79170cb00fed239d36da1a95049f"
    sha256 cellar: :any_skip_relocation, monterey:       "a2422aed41d0e50337d90612e7e77b39838aa1f84dda4c7df0f191065aabb18e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c50f20179676899896fa400beff51885ce33445852f246f3de7143126316323"
  end

  depends_on "go" => :build

  def install
    pkg = "github.comapernethysteriaappv2cmd"
    ldflags = %W[
      -s -w
      -X #{pkg}.appVersion=v#{version}
      -X #{pkg}.appDate=#{time.iso8601}
      -X #{pkg}.appType=release
      -X #{pkg}.appCommit=#{tap.user}
      -X #{pkg}.appPlatform=#{OS.kernel_name.downcase}
      -X #{pkg}.appArch=#{Hardware::CPU.arch}
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