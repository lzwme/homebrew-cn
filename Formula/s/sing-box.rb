class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  url "https://ghfast.top/https://github.com/SagerNet/sing-box/archive/refs/tags/v1.13.19.tar.gz"
  sha256 "abc2f4805b3fd088c18a5694b51fed6f0e1d06632fae98029d6bf7bd79a1b3a2"
  license "GPL-3.0-or-later"
  head "https://github.com/SagerNet/sing-box.git", branch: "testing"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d54e3adc651237d01d5f3f62d5424284914bee933d83c46f9d1683aacb1fa23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a943c5c518ed1367ba482a03aa1c6152c1379ce7bab6013e90197afbf34ebe7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4445667164f077e3a3457b035a522905badae3da034eeb2efeb1075dbecf427c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee8293e5b5b8f951c5c6a3e13f96cef5800099d288e6edb125163656b133859d"
    sha256 cellar: :any,                 arm64_linux:   "28e18def0cfcdc45deec7fba38362923a71d5002e67c42c1aca68ea267c20117"
    sha256 cellar: :any,                 x86_64_linux:  "e441d31f2a0f9b9de27c578f93f26040d1e4408518757cd3b7c0dbbc2b034090"
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