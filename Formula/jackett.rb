class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.20.tar.gz"
  sha256 "cd91b79786174f7995339b346bb32b4f402ec27c2704d8d292af14084313941a"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1a3b19b7089a94593276352a3cd89d7699bd7bc25f3a61a1c272a478b949886e"
    sha256 cellar: :any,                 arm64_monterey: "baaf3b8c499d67d8086c5d3ab74a0513ed91c998e5fd5181f13e071bd9f33751"
    sha256 cellar: :any,                 arm64_big_sur:  "e6d5b1906ab922aa80dbe636a5add1de2b8653f642d4eeb0c50ef6e4d0d75891"
    sha256 cellar: :any,                 ventura:        "a7c19db3ae8b5ef224d37303b5f7787d9904e4bd40e6644495080bad5d80a8d9"
    sha256 cellar: :any,                 monterey:       "8d50e85aa8191a1a7387517b943495787aa56b3d09846aa48614e1c09820ec74"
    sha256 cellar: :any,                 big_sur:        "6f181a98ff011fc5dfb88158035c5c516bd9eeaaad5c6480138b1176bee7424b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28dbfb429432396cfb3f9bb01808d637e3885a811d0bdc17eb702427389be87d"
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