class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2330.tar.gz"
  sha256 "fcd7e4e74af9b1d5bb4fbcc789cf9179240c144ca0bc2b0e1ab227c76779530e"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d7b0995fce3dd9e1945a79fdbefcae173ba7c84c1010465c758449b60646da80"
    sha256 cellar: :any, arm64_sequoia: "d5432d3cf0381598e14aba83fb1b66167947a004e2456db4761919348b680b72"
    sha256 cellar: :any, arm64_sonoma:  "738c3b7ac0c1e66ee89e289d39ae68ea1f2a72578dc728e09d4eb25450ab4fb0"
    sha256 cellar: :any, sonoma:        "9c41a51b8fae80e5775a4be8dfce0dbc9a1da779312f59b04d01fe5151071d73"
    sha256 cellar: :any, arm64_linux:   "151ffe2b651746b24690cf5a949984c078c28bc07fd3bd1180594135698bc221"
    sha256 cellar: :any, x86_64_linux:  "86ef40913c66babf65ce510fe4f9e90794be7cb93b09df0cae2abf2b0745a3bf"
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