class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3670.tar.gz"
  sha256 "bc8aa77de8356e97fbf7ef6ef4ed6fc5fe22e0ece39a4eef2099fe8e7a8f149b"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2e14df2ac7877804fc7281a2944d2e8909ab8d30c9285eb094d18cd035ef236f"
    sha256 cellar: :any,                 arm64_monterey: "d3e09cd73fe8d4b2a9646a6566685d016d539d3b168489e71da1fa89b56b6c5b"
    sha256 cellar: :any,                 arm64_big_sur:  "da738e3c6ab38732a5e4494f794de2abb5395bae9926e8774e3463879f8a76b0"
    sha256 cellar: :any,                 ventura:        "7381199384d10789e1453f8efd72083153be858198720a14ea18d7663473aacc"
    sha256 cellar: :any,                 monterey:       "722e52c96b399bf84e40bcabe673cc8614525e195de0c2c683df16ab4156a29d"
    sha256 cellar: :any,                 big_sur:        "e7ab0c0c4e7ea2de1021221c87b3621f60b7581242ceca49b72feb1d8a79392e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b3a9c76bb31d3e59197e7dab18b767747ff6ec5f7275bffc76186bde4b6327e"
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
    working_dir libexec
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