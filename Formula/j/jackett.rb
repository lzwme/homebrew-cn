class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.569.tar.gz"
  sha256 "842b81996c22b6574053543a49c16d4c3fe78fd2257b5e736b1e6cad722c3eb3"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f0a2a8c6b6a75c1afa4d91c7d83ae2660a0ec663727de9d46f4f9c2d3fe66035"
    sha256 cellar: :any,                 arm64_sequoia: "51fe5c400318a98f1d056b58e1cbf3eced27c36d152aae02b1682dffd2054af6"
    sha256 cellar: :any,                 arm64_sonoma:  "54bc15d013725ca26cb246edcc46ee0b5a012a90f621cf7bff6ea9b07c387035"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "007c556761fe0884815922254459d5d6b47f77d7ff678f780a2f2e52f05c5cc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15af3e8cf0136f1d95b6338742c2fae6c96fd6d8e11f877edb4f3ebbfd483161"
  end

  depends_on "dotnet"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    dotnet = Formula["dotnet"]

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

    pid = fork do
      exec bin/"jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 15
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end