class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https://hysteria.network/"
  url "https://ghfast.top/https://github.com/apernet/hysteria/archive/refs/tags/app/v2.11.0.tar.gz"
  sha256 "a0f2fa1c26ef8a1f2d48d66253444ba528e7ea78ad8b1588e066abcb85b311da"
  license "MIT"
  head "https://github.com/apernet/hysteria.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18a61ac75d803e2d0d7ad6115dac4d33e37cfcd2b0806684c8191fd0b4c2dd16"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18a61ac75d803e2d0d7ad6115dac4d33e37cfcd2b0806684c8191fd0b4c2dd16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18a61ac75d803e2d0d7ad6115dac4d33e37cfcd2b0806684c8191fd0b4c2dd16"
    sha256 cellar: :any_skip_relocation, sonoma:        "38da9ebb422f260bd709b898e11fd7676752aaf28ce52020ce42ab1fabc1b45b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "024fa3b6b3b07d6b3a3375990e74bd9876cef297db34607c8392cc532e869cd1"
    sha256 cellar: :any,                 x86_64_linux:  "44b1cfc9ede02b626c570f69a0dd94d22c73016bab39d17a9ba71a67c3377c65"
  end

  depends_on "go" => :build

  def install
    pkg = "github.com/apernet/hysteria/app/v2/cmd"
    ldflags = %W[
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