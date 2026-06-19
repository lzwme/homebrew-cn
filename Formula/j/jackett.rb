class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2079.tar.gz"
  sha256 "911be1053bee511ee71d719f02b244e62b8efa4227c121f0f9a0db9a47bfc255"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "82d3c658bc37db8c549e6bb7231eb367bc016e7a9f7c1d3a7ffb00ef5a75bb32"
    sha256 cellar: :any, arm64_sequoia: "10f824d3815f2bffee6f513ee0cbf0f60be447157dc40a7c16b756650bc3b05c"
    sha256 cellar: :any, arm64_sonoma:  "a460db89447156bda9348b4f58f4c876dda817f9fad8541936f91044548061f0"
    sha256 cellar: :any, sonoma:        "4a8081955d4c405d4e6453ad1c0b965dfea09c6a1ffdff9479bf25b2e06dedd6"
    sha256 cellar: :any, arm64_linux:   "4c9177f2bf74bbfe47a49de35f6dcd9cbcdb8cb6fa8e1c9d3b1b7a6ecca2e2a9"
    sha256 cellar: :any, x86_64_linux:  "ded7aac59b9ae574305e72eb82ff38266d36a65f2dff08f2b9850f2262a44407"
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