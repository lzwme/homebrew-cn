class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  url "https://ghfast.top/https://github.com/SagerNet/sing-box/archive/refs/tags/v1.13.15.tar.gz"
  sha256 "b43456c0cb2d4d7b81664010b2149a35ed6e3f6c245d78bcc7caf27c46eca816"
  license "GPL-3.0-or-later"
  head "https://github.com/SagerNet/sing-box.git", branch: "testing"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "786e4f1fa08e2c70618602e9ec1d759bca61de33a7e22a47ef43f8923a5642c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ead1e281d0efb3872ed0b6efac41c930cd2f78ab963e6ea673f46fab1376c73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c138fb5ece1781b0c1403a600ce847655dcc18c171c95abd1e1c505df0aaea03"
    sha256 cellar: :any_skip_relocation, sonoma:        "e0d278c566334c5f3d497467f9872a91a8b3c37dae33d872f6404991dc4f2716"
    sha256 cellar: :any,                 arm64_linux:   "4049b5acedbd7d0a8efbbca034e2549b398657a4274064eee9e8d5249d9bae5f"
    sha256 cellar: :any,                 x86_64_linux:  "e912651840c22f31513625f2f902fec7965302f177a0cd29f87f72ec992fd4e5"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "lld" => :build
    depends_on "llvm" => :build
  end

  def install
    tags = File.read("release/DEFAULT_BUILD_TAGS").strip.split(",")
    ldflags_shared = File.read("release/LDFLAGS").strip

    if OS.linux?
      ENV.llvm_clang
      ENV["CGO_ENABLED"] = "1"
      ENV["CGO_LDFLAGS"] = "-fuse-ld=#{formula_opt_bin("lld")}/ld.lld"
    end

    ldflags = "-X github.com/sagernet/sing-box/constant.Version=#{version} #{ldflags_shared} -buildid="
    system "go", "build", *std_go_args(ldflags:, tags:), "./cmd/sing-box"
    generate_completions_from_executable(bin/"sing-box", shell_parameter_format: :cobra)
  end

  service do
    run [opt_bin/"sing-box", "run", "--config", etc/"sing-box/config.json", "--directory", var/"lib/sing-box"]
    run_type :immediate
    keep_alive true
  end

  test do
    ss_port = free_port
    (testpath/"shadowsocks.json").write <<~JSON
      {
        "inbounds": [
          {
            "type": "shadowsocks",
            "listen": "::",
            "listen_port": #{ss_port},
            "method": "2022-blake3-aes-128-gcm",
            "password": "8JCsPssfgS8tiRwiMlhARg=="
          }
        ]
      }
    JSON
    server = spawn bin/"sing-box", "run", "-D", testpath, "-c", testpath/"shadowsocks.json"

    sing_box_port = free_port
    (testpath/"config.json").write <<~JSON
      {
        "inbounds": [
          {
            "type": "mixed",
            "listen": "::",
            "listen_port": #{sing_box_port}
          }
        ],
        "outbounds": [
          {
            "type": "shadowsocks",
            "server": "127.0.0.1",
            "server_port": #{ss_port},
            "method": "2022-blake3-aes-128-gcm",
            "password": "8JCsPssfgS8tiRwiMlhARg=="
          }
        ]
      }
    JSON
    system bin/"sing-box", "check", "-D", testpath, "-c", "config.json"
    client = spawn bin/"sing-box", "run", "-D", testpath, "-c", "config.json"

    begin
      sleep 3
      system "curl", "--socks5", "127.0.0.1:#{sing_box_port}", "github.com"
    ensure
      Process.kill "TERM", server
      Process.kill "TERM", client
      Process.wait server
      Process.wait client
    end
  end
end