class SingBox < Formula
  desc "Universal proxy platform"
  homepage "https://sing-box.sagernet.org"
  url "https://ghfast.top/https://github.com/SagerNet/sing-box/archive/refs/tags/v1.13.5.tar.gz"
  sha256 "e429a655f5301e4d60e0011fb34f1c7abcdf4035d6f8e32081cfad2031383b2a"
  license "GPL-3.0-or-later"
  head "https://github.com/SagerNet/sing-box.git", branch: "testing"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd8749e2628e971b6cbde786f7b34d70544fbcab21001d7c52cd09749db84082"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbe91e4fce70dcb5a6c550b7e5e3e5c640b4c9913c9c50687bbd327e3585b88d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46002ad65e43bc8ba49576c919dcf80ec7c8fbeb72224478016446c0d8059aea"
    sha256 cellar: :any_skip_relocation, sonoma:        "5cbc033c5480073b10ca07e79d713272ba1fc0723c52fb66665bdeb004f14f54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59e6ad23837f7fe15bfe3990dc422c41f962a92a380f8048c11b135d1672442f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d927ced7ea35fdf23e817c1dc9a1fe99767472c66ae28dc00e9ea5909910c69c"
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
      ENV["CC"] = Formula["llvm"].opt_bin/"clang"
      ENV["CXX"] = Formula["llvm"].opt_bin/"clang++"
      ENV["CGO_ENABLED"] = "1"
      ENV["CGO_LDFLAGS"] = "-fuse-ld=#{Formula["lld"].opt_bin}/ld.lld"
    end

    ldflags = "-s -w -X github.com/sagernet/sing-box/constant.Version=#{version} #{ldflags_shared} -buildid="
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