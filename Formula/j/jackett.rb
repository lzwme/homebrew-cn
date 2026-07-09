class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2187.tar.gz"
  sha256 "66da612715bd1fd6ddf595061d9dc035c11df2c8b1a28ac97a7a4812c6662485"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1a63b87c8358c70a5f08590a0e22a1b4410746feea9ce0b897af9fe186c47944"
    sha256 cellar: :any, arm64_sequoia: "1c3ddb3da584341d48ffe22dcc574422cc98a2d2764c4f8b006771521aff1a04"
    sha256 cellar: :any, arm64_sonoma:  "96f5a93e39394671cb5afd2b722898c2e96695ee65fc2de546481e195e5c73c7"
    sha256 cellar: :any, sonoma:        "7c89fef2511d01fef5aa6b25c4679afa18ab0f83a492db360ace12716bdb6a87"
    sha256 cellar: :any, arm64_linux:   "c3cb8c6ae64672efc9a1dd9df585dfc057b91412ba34898cc81036f50adee056"
    sha256 cellar: :any, x86_64_linux:  "d2fb588a20fada4f258b05d88a49d7a531c1ec63f24f79a93ec563de446b22bf"
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