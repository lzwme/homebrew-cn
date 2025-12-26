class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https://hysteria.network/"
  url "https://ghfast.top/https://github.com/apernet/hysteria/archive/refs/tags/app/v2.6.5.tar.gz"
  sha256 "21a04ef8ce640d7c60c3b8678500b6e6481862d9af62f9ce2663b772211718d0"
  license "MIT"
  head "https://github.com/apernet/hysteria.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6ee206f011999467cff5ac4002651dc077c4f66f0cf0c64086098b83e1acb60f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ee206f011999467cff5ac4002651dc077c4f66f0cf0c64086098b83e1acb60f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ee206f011999467cff5ac4002651dc077c4f66f0cf0c64086098b83e1acb60f"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b32f93d5d9f0b2ddae565cc876552da488dbcb8c892e36531ef291e98a4354a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf1220273d9b4569b1250037cb6c75084462a9a81c0b5b0d0ad3ced76a7080a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8fb5cc6d2a466025a2dc85904dc613a8f26ffe57e45bcd139130af211493a05"
  end

  depends_on "go" => :build

  def install
    pkg = "github.com/apernet/hysteria/app/v2/cmd"
    ldflags = %W[
      -s -w
      -X #{pkg}.appVersion=v#{version}
      -X #{pkg}.appDate=#{time.iso8601}
      -X #{pkg}.appType=release
      -X #{pkg}.appCommit=#{tap.user}
      -X #{pkg}.appPlatform=#{OS.kernel_name.downcase}
      -X #{pkg}.appArch=#{Hardware::CPU.arch}
    ]
    system "go", "build", *std_go_args(ldflags:), "./app"

    generate_completions_from_executable(bin/"hysteria", shell_parameter_format: :cobra)
  end

  service do
    run [opt_bin/"hysteria", "--config", etc/"hysteria/config.yaml"]
    run_type :immediate
    keep_alive true
  end

  test do
    port = free_port
    (testpath/"config.yaml").write <<~YAML
      listen: :#{port}
      acme:
        domains:
          - your.domain.com
        email: your@email.com

      obfs:
        type: salamander
        salamander:
          password: cry_me_a_r1ver
    YAML
    output = shell_output("#{bin}/hysteria server --disable-update-check -c #{testpath}/config.yaml 2>&1", 1)
    assert_match "maintenance	started background certificate maintenance", output

    assert_match version.to_s, shell_output("#{bin}/hysteria version")
  end
end