class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.860.tar.gz"
  sha256 "43b769ae7eab80dcbb50cbc96270c37b0b77f60ca6a6632574670f4073b8f941"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bad4dbd44d3ad7201acdc65358c4fd68e40cf4ca49cb2685a438d2f8a757aba5"
    sha256 cellar: :any,                 arm64_monterey: "4dcc39af1c11170a8847ba03f8b6e9ef14d54854b51d1681ad4f91d00427650a"
    sha256 cellar: :any,                 arm64_big_sur:  "c096b4bb19e0a4c333c0eca2e5db63880da6388ba79a6d0d4f0aee376ff00dcd"
    sha256 cellar: :any,                 ventura:        "e3e6118fd6abc267fc465602284af747d5e688e67706fd25ac5b9bee8ac504be"
    sha256 cellar: :any,                 monterey:       "f89417ef46560472a66aeb96dc8878fe195c87b200a1b8a697146541755d89b0"
    sha256 cellar: :any,                 big_sur:        "ed9d263043195895d777fee322e3e8ec52a331e4d21397f95ed7084d41a39ad9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9a6c1b4dc48219b8d12e5868b65690e3be95c4fedf3377e84bfda837fc0e5fb"
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