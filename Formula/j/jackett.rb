class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1954.tar.gz"
  sha256 "03b9a1578cc27aa49b1844ca556f0d117e311e71e3f5c74a8b6e8f60d35b76ad"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8efefed634151fcf056c2eb246db7fa2692f220bb61d60ec38104caa31c5a79d"
    sha256 cellar: :any,                 arm64_sequoia: "c20482baddcfb9befe8ab4279a91befc73673a088df0c1e15420c741d1c79034"
    sha256 cellar: :any,                 arm64_sonoma:  "3d7ee5e65ba80ec5166779414abb538a082382030e70902d47ebbd44b593328a"
    sha256 cellar: :any,                 sonoma:        "3289def8c156bef8cbc2c681e8100362371843817d32cc4f2d42d25ad69da7f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b5233b240289b47acef45ae1c4727c2e2cd31e276f07a0c5a806b4789979eb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8b58162ea55181e8a1f441d6d18dc5425856f07a8648bb053a7e752a4efd0c5"
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