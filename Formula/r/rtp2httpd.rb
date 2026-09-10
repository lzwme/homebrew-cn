class Rtp2httpd < Formula
  desc "Multicast RTP/RTSP-to-HTTP converter with web player and status dashboard"
  homepage "https://rtp2httpd.com"
  url "https://ghfast.top/https://github.com/stackia/rtp2httpd/archive/refs/tags/v3.17.0.tar.gz"
  sha256 "37d1914aa6672fc43f65b3e242a6138e741345ad19cfb774ad32e6d46e77f12a"
  license "GPL-2.0-only"
  head "https://github.com/stackia/rtp2httpd.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "f3e396645bb09080ecdd1d308283ae888d5bcecc942b98dd2d05b31d825b9728"
    sha256 arm64_sequoia: "8095d19b38a6eacd30c2ab60993ef6431c59849c6933a6c164aac308e1c5c49d"
    sha256 arm64_sonoma:  "fa17cb3189e6973c14b8352d299b22c4566c3a363d5c284336d3ea40457c89cd"
    sha256 arm64_linux:   "7c1814a700c4e27f1278b4e5bb758b1ccfed26832efdff646f7bc70ac866309f"
    sha256 x86_64_linux:  "5abb3dc403b16a2248b4bbb45df2ca61a2afc5b58c2b5792b691823d6471724f"
  end

  depends_on "cmake" => :build

  def install
    ENV["RELEASE_VERSION"] = version.to_s

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}",
                    "-DENABLE_AGGRESSIVE_OPT=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (var/"run").mkpath
  end

  service do
    run [opt_bin/"rtp2httpd", "--config", etc/"rtp2httpd.conf",
         "--pid-file", var/"run/rtp2httpd.pid"]
    keep_alive true
    log_path var/"log/rtp2httpd.log"
    error_log_path var/"log/rtp2httpd.log"
  end

  test do
    port = free_port
    pid = spawn bin/"rtp2httpd", "--noconfig", "--listen", "127.0.0.1:#{port}"
    sleep 2

    assert_match "rtp2httpd", shell_output("curl --silent http://127.0.0.1:#{port}/status")
  ensure
    if pid
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end