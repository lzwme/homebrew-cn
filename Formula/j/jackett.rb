class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1614.tar.gz"
  sha256 "02099ed4548feb807bd1ab0a21a1eb961c07bcd274e1f9fa14252361862eafcb"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c29de3f12d6b1ca643fd6270b569db568cfbfc91b6e5ce99c871f79d4f6a6be3"
    sha256 cellar: :any,                 arm64_sequoia: "5f3b0fcda9828aac8eb856757b45b3f5082b1336f68eac7924fc23ed5aa547a0"
    sha256 cellar: :any,                 arm64_sonoma:  "5b36e28509d0c0cb9226cfdbd00932b0e4c571767ff44c7bf164ea2ff48bf4b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "165864d6af3831496f8fd38d846a0cdd43f3aba2ba887c97f274bb5918f3a0f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a5fccbc938c1a3b59bc3a7452556b36bc534340725ac4a25e68e23671279949"
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