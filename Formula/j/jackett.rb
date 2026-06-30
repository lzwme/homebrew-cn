class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2140.tar.gz"
  sha256 "0681ea98b7176295bfa701e92f9cefeb77d4eae452862e2aed63230f337bb2a0"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a71695a384c77e7d5a231c3ba6547560ba60921764b2f54f8fb42520a5e644d7"
    sha256 cellar: :any, arm64_sequoia: "39d164916de917341ee622308907b59bc3853380204f4b9cf8f8f8414d2d5065"
    sha256 cellar: :any, arm64_sonoma:  "c5526e03ac6e4110bc2184202dc58c95687fa95350ec8184120598a91cd80c77"
    sha256 cellar: :any, sonoma:        "0b79de0bba05f9e6636ba1451b94937d479d9cd20bc2f48ee95e7d1b20436262"
    sha256 cellar: :any, arm64_linux:   "340b4c99ad6c41f2cc01d76aac8fdb5743ede923e1b6b804d545264d90a44001"
    sha256 cellar: :any, x86_64_linux:  "33ebef01780dbcb4b8376d5016e2b948428692ad25e09a411ce53150317c1f06"
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