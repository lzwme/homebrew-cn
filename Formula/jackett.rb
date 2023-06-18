class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.241.tar.gz"
  sha256 "a32460cd12ecfcaa4ce766101759aa53939d9df44314fe84245d4552c3b8b43d"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "107011ef4b54d01333ab3f701e257126230aa3cd632c3fb23a1f225d4369a47f"
    sha256 cellar: :any,                 arm64_monterey: "94c992d3ac44db26100b4242510ed899068918f4a732a8a59168596faba20f14"
    sha256 cellar: :any,                 arm64_big_sur:  "90519980ab1e3061cf0fa9a3fba4c55ab8708a36341047de4d22cda37add74b4"
    sha256 cellar: :any,                 ventura:        "2f2fad7b4aaa108986e2a98d44cff2785d52c999cf575ad392e87f514f1072d0"
    sha256 cellar: :any,                 monterey:       "63b3701bed7825e932615ab5e4b7679cc0ce13367ba1fd26730edfb7cce7b1eb"
    sha256 cellar: :any,                 big_sur:        "2815c87f6d0a391b944cf26a73968913e1910cb9c6909f275ba4aac9e42e22e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2fef24c2368c517ff929321dae41fc040611a27c305bbee596358893cc63519"
  end

  depends_on "dotnet@6"

  def install
    dotnet = Formula["dotnet@6"]
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --runtime #{os}-#{arch}
      --no-self-contained
    ]
    if build.stable?
      args += %W[
        /p:AssemblyVersion=#{version}
        /p:FileVersion=#{version}
        /p:InformationalVersion=#{version}
        /p:Version=#{version}
      ]
    end

    system "dotnet", "publish", "src/Jackett.Server", *args

    (bin/"jackett").write_env_script libexec/"jackett", "--NoUpdates",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  service do
    run opt_bin/"jackett"
    keep_alive true
    working_dir opt_libexec
    log_path var/"log/jackett.log"
    error_log_path var/"log/jackett.log"
  end

  test do
    assert_match(/^Jackett v#{Regexp.escape(version)}$/, shell_output("#{bin}/jackett --version 2>&1; true"))

    port = free_port

    pid = fork do
      exec "#{bin}/jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 10
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end