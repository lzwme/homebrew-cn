class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https://hysteria.network/"
  url "https://ghfast.top/https://github.com/apernet/hysteria/archive/refs/tags/app/v2.8.0.tar.gz"
  sha256 "7509c0ad77ec3f5828a962b7136d51c36e0b0ddde4b5fccdabc6403a75562720"
  license "MIT"
  head "https://github.com/apernet/hysteria.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2a7f2080c460c26cdee9ff5c57f50d7245a321d543af56e681700adb71c707a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a2a7f2080c460c26cdee9ff5c57f50d7245a321d543af56e681700adb71c707a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2a7f2080c460c26cdee9ff5c57f50d7245a321d543af56e681700adb71c707a"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc353374c9be4703b5395392e095d8d811d070a90d2bea77c3e5234a6257065e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a93e99f76c4c145feb0bf32bf29a77eb26e2c664399a0a5bd7098adf67a81c11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ebc2863a0ab0e71a78c72a700abb16008eae60af88a44a3faf14ad3ffd93126"
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