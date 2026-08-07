class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https://hysteria.network/"
  url "https://ghfast.top/https://github.com/apernet/hysteria/archive/refs/tags/app/v2.12.0.tar.gz"
  sha256 "0c37f3ddc51a80e0c33425380d09c045045ce68b7fa6453e2ba27a986e65d9f5"
  license "MIT"
  head "https://github.com/apernet/hysteria.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb55c2ae44ec6bd7a4653df753b5826fc117869150384527ac41a0c903dd1a24"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb55c2ae44ec6bd7a4653df753b5826fc117869150384527ac41a0c903dd1a24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb55c2ae44ec6bd7a4653df753b5826fc117869150384527ac41a0c903dd1a24"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e3fc2192710db80bc229cb8641a8f6ab5121abf28b528d20597454ffb90a5b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40906be4246b99b689fc2c59d9b619c5637ff5ffd98d3dc1c1efce12038955ec"
    sha256 cellar: :any,                 x86_64_linux:  "565a0aef4b1b7b307cd299995da8a521e84a5d164f4127c73fc95210e7dc9a6e"
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