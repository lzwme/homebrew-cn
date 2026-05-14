class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1849.tar.gz"
  sha256 "968f9df25c3bf3e54f8a12a5bae648da0379eda60426559418092d65244fc5b4"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5688b31889af429f982a6f0d5e379d7e76e6cfcdb0c298d98e085429e35a47bd"
    sha256 cellar: :any,                 arm64_sequoia: "bed0d533369b905c6531648c8ce60fb55d4ec76cc88c6c5ee3b9d5bc9fcbc34c"
    sha256 cellar: :any,                 arm64_sonoma:  "f56798ccc7afec632d87044401d49006917d16c83926b1d1e3f95ae3855424cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d014c5625f7dbbcd8e4a01102e1320cb7256c48872ab9d34f7b48423cdaff70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d863f1bd12d46c8a67387235d7ed13b65f540041653f5d4527c734e656d411f1"
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