class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2254.tar.gz"
  sha256 "9edfa7429fea08de620d0fd04f97e1310be50cf80f1508a6a5e6bb383e44faa3"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ccf517b4be42db856f970f1dd084fc62a8d2c3ed2066b1519771b5c29cc345a8"
    sha256 cellar: :any, arm64_sequoia: "8480e8124e6ed2e116981ff927320ab29ddffb625a878bb58a6f2830f2fd25b6"
    sha256 cellar: :any, arm64_sonoma:  "872ae7133bbc4596bebc75da2b9de9fca7d97af478ec627e6ecd752b9549c830"
    sha256 cellar: :any, sonoma:        "a8a733514957b134847f7880d5c28515b88c3c77000cdb5f080383842d35e9e0"
    sha256 cellar: :any, arm64_linux:   "bfae863b6b1e072f9564072b83eabf05c2f2351bc87e92a4c5d68b2382ea9662"
    sha256 cellar: :any, x86_64_linux:  "f762febcff5439093344e3b549ab08b2438d314a7609d5f07301581c8275fd0b"
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