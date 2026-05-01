class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1806.tar.gz"
  sha256 "efa5ab27d0a5961a9232ce4df2701792ed70711766ee339487e47431741cff99"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "348ed948b4afc589858bbcb6bc53e938314bd67a90e59afebb5a576f9defcd02"
    sha256 cellar: :any,                 arm64_sequoia: "2a63e84b10e36acf92e32712d57d583a548b1b2c694bb9e3200ace0491adc849"
    sha256 cellar: :any,                 arm64_sonoma:  "65c3d0e4f82f47f0b4bb958f4d5bebb9d53834a7307c4d0f321be39a401afe78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2dba9bfd199888f83e74ff9a5c915c2d6da088e1914688b39d21df237fe36fb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4cf19c61055900456a085466ab35065a36d17b5151ba0d20f2b64fcf5de3cdc"
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