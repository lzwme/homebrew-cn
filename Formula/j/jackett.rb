class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2360.tar.gz"
  sha256 "8cbed43c2026c42fbe8ace5f586e60832cbbadc43d6fd53bea5cab11fd4ef931"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "65ea475df57fe6cf9db4b2944f606d186a65e7e0be5e2572436dbf6da06afed0"
    sha256 cellar: :any, arm64_sequoia: "3a470a81af8ae4b14ba9cb26ff538870406700f8af338d3f319f094981d5fde1"
    sha256 cellar: :any, arm64_sonoma:  "80cc492dc41ed29a7be5e42dc972797e3831445ebb5cb35daf301371ed92a8ca"
    sha256 cellar: :any, sonoma:        "cd29e367545958fceaf3580b0d43471a290908ee4b488bfa513aed397a09a2ce"
    sha256 cellar: :any, arm64_linux:   "b0814de5145aaa18e633cce25e858584ef524f726d0aa8763b59bbf10372e8e6"
    sha256 cellar: :any, x86_64_linux:  "0ecabfa5e5e570767d20d712b3addc844bc3b993b22b9a4de71f99568021dbc8"
  end

  # Aligned to .NET dependency. Can remove if updated to latest .NET
  deprecate! date: "2026-11-10", because: "needs end-of-life .NET 9"
  disable! date: "2027-11-10", because: "needs end-of-life .NET 9"

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