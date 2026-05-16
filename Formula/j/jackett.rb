class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1866.tar.gz"
  sha256 "890a3db9386d111944f18c0245f758e6c8f41d0dcf1b25110a61d3b19c8dfe15"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "799ff792b4c3220fffbb6befe9b309c6a7a94473dfb2adf9e449d1c56a0b7538"
    sha256 cellar: :any,                 arm64_sequoia: "78779c9a881a755fa6b31b1691589443244abe22399aef5896151e34aa4ca1de"
    sha256 cellar: :any,                 arm64_sonoma:  "3fa672c0b760ff866e33d3974fadebd3f52d8e61a4b3dc0479792c7a8aa3d765"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd1c9df368b074f92f7a37742c513d651286ac9e56b8bca756f22516558bec3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "627834a7ce219339842f87731d558bddc7cf9f15eb86fbd43e7b757d2d9dcd17"
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