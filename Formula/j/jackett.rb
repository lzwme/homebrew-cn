class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.101.tar.gz"
  sha256 "5cdb1d09620ca2a0a257bc3d6a924eb55da5462472aea57d5fb8f8caa58b0aba"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e98501c3346d5f535a67edc264d5c5acc6e7977af06438eafcb610e6e4e40bf4"
    sha256 cellar: :any,                 arm64_sequoia: "617fe9db0f1c0e80dbf83ebcfa8989a3ef956568c316d8a756b8fac2237bc46d"
    sha256 cellar: :any,                 arm64_sonoma:  "ee64058d236f6007f0b256144148549beaeaaf7992eba3b782c8c1386a1671b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8683a1969228451f9b7f42a7b8daecc4f58d460303a45618274c22c0f5056137"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d95ba35945d6bd97136a9cdd48078f1708fe0309e140c4768cd342b57dd8d07"
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