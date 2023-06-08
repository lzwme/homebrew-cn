class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.166.tar.gz"
  sha256 "55ef19d2f35a1558da69ed2c834ff605afb0f997f6d3d2c0301fe5f1d9fe25df"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bc485d7572bcf4e50fd8d1c2c6af99809e59cd6a34f342b5d045085ca835422d"
    sha256 cellar: :any,                 arm64_monterey: "05bd5c3003b89561a50577a79cca485cc21aa73575d78308bc175ebd118c0f01"
    sha256 cellar: :any,                 arm64_big_sur:  "e4420bdbe8b86844d7419a3978e39a4cfe8e7b13261c8cbc8a5a9455ca538193"
    sha256 cellar: :any,                 ventura:        "57e486a2dd05dfb29582d4c897b1c5a06e097352700902ec8b01d4a7dd7e037c"
    sha256 cellar: :any,                 monterey:       "b52dca82b4a8d73dabe76aeb9c5e7bafcede0c5d4d930a2b2958909362bc5ac9"
    sha256 cellar: :any,                 big_sur:        "84292d43c5e70e6004cac655f89e6a2c3962934206b0e44dda9d3f15a8c50ba1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54f50b82162dd6b17ffb89f73af87f3f05b343efd55ff45ac2db4fd591d11042"
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