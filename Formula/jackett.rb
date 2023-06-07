class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.157.tar.gz"
  sha256 "fe7367df7717154136a848ccec8951e88df56774c502fdf8d8481d7acbfff212"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "77b6c4d3872b221c5c589179ed8e30be9766750c68b11e4699116df17b1186c6"
    sha256 cellar: :any,                 arm64_monterey: "16588397ba52bdf2672bbdc4b2e70f2d2fe53903a14d81f60749a3ed5a8f49a4"
    sha256 cellar: :any,                 arm64_big_sur:  "f4f509a576ecd268a2adef04a10e4207ea29022fb041325d585e90eef5fe955b"
    sha256 cellar: :any,                 ventura:        "50dc8311d9c448d416bc534c9a997fbaf17f8938bcf245075d3576b406465d11"
    sha256 cellar: :any,                 monterey:       "fb59f7ce7d87b156619995c854926b00a54d5ff11d48179170ab878361b1a23f"
    sha256 cellar: :any,                 big_sur:        "5af41663b958e65d536e05e1490747aa7dd93f35cc323f1224dcadf2a729f7f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a215df0483c52ba9a41d86eb23b6e582e38d021b33e9f50b912589206cfe4081"
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