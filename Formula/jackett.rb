class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3840.tar.gz"
  sha256 "cafac5cb82f5114a5d251c281bff687a0952f65018de0af60fe808f1e03f9674"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "14c065fb3abe28768f44c2df1ee4363e3aec284733ed40b08ab3737d20802202"
    sha256 cellar: :any,                 arm64_monterey: "c56940abfc69185b47e782219bd90810f4b3542f39c8afbdc87ce1d12a9f319c"
    sha256 cellar: :any,                 arm64_big_sur:  "5c104199d31a63aec7c8433ad8a60fc5da7e919d9e3d69cf9f99a8825a4d352f"
    sha256 cellar: :any,                 ventura:        "6e3bb43a32815d5b8cc6a7cbccef59e6195d3838ff448a434fad36ae1cc9b9f3"
    sha256 cellar: :any,                 monterey:       "9a1a779efb5830f5dae3523c0df71a5ef3a03dd3060d31bb2f49926ecbc0015d"
    sha256 cellar: :any,                 big_sur:        "e0c6d36890a97ca9cb414d282bb7ddd1a9a21c135b54416187232dc03f273c5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "523956205f2131aa1886749613682c6ae1a7c81777cf05f6d1a9032342c0ce43"
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