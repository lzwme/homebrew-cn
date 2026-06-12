class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2045.tar.gz"
  sha256 "78768fbaabc08c48a364c9ffbef0eb44e78e9d356b299874f08116a4c45feb90"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "696ce14c8c340149d19c80a69f3c990cbfb9319b472280cccd30faa761fe4fce"
    sha256 cellar: :any, arm64_sequoia: "816fb841223f3f1cb13bfdd6ca377096767e1022093fa993dbc459c8553ac23b"
    sha256 cellar: :any, arm64_sonoma:  "c78f1aaa500cfec5ef95af42749889ba42202a544370367700294c25d76d65c5"
    sha256 cellar: :any, sonoma:        "143eaf20904fcb593048a8f70247ee7aa29e48a20aa2585912caba1b53b3174d"
    sha256 cellar: :any, arm64_linux:   "1aac48d1f72b0964893be2650e6dc45c94f5faf05962ba802a584f9fb2057b55"
    sha256 cellar: :any, x86_64_linux:  "4725a2450cf21b7d56e83113eb0b099076a11d7eae7409130f36a10c26165d5b"
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