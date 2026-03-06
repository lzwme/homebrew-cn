class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1287.tar.gz"
  sha256 "20785a612681153fd748f5230622fe27d543a7f3e027ae1ef4558fc72306494d"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "442626a401c6a3f5c39e1b63eb4f2b02e05cee838cc6f31fdbfeb84c079e3df6"
    sha256 cellar: :any,                 arm64_sequoia: "c842cb2a7e4e382e23ac17e109183a911491a0f30b7e4dc8a8ab48fda959cf12"
    sha256 cellar: :any,                 arm64_sonoma:  "63bf376780132823d2a85fa59538731b6d68b233b0f90c6c0fc543a27bdffff5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0edd49aac717266ddedeb697a68a2882e00d341165df7300775beec5554392b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45821b5693dd7880cda4678ab6f185c500e1075e3a6b2fc99b50398c86fd373b"
  end

  depends_on "dotnet@9"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    dotnet = Formula["dotnet@9"]

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
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

    pid = spawn bin/"jackett", "-d", testpath, "-p", port.to_s

    begin
      sleep 15
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end