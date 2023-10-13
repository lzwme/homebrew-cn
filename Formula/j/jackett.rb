class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.1011.tar.gz"
  sha256 "a73c24fa13270ff4c754917307aba41822a55731c60737ba0d99c4c5f9fedab9"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3bed5e0eb99fc3e415eac61b794892e111a21fec6e4b5a2de8294c939d4cdbfb"
    sha256 cellar: :any,                 arm64_monterey: "a4348e1ed3371994daca27f039429edc30af24cc5624ce12654f16c12d32f72c"
    sha256 cellar: :any,                 ventura:        "f581d80d8ce446a5505b4204d5fd6dd9b0d8f3384687e6822fb339655bf32d51"
    sha256 cellar: :any,                 monterey:       "efcb27762a5037d19b9645a24148c32a3c7b2e08355f2e9b5c2a1435b08983fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "acd4f71c0e94d0b87c5f00876bf6162a76143da78596f722099889c80934e396"
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