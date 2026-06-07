class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2027.tar.gz"
  sha256 "f755a5315a78100c74da3472d4137a45307fefbd30fde8f7fac35eeac840f7ae"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d9abfa19f884e9c8074528736906d3078135472d18b29c5fddc546bd674ef1c2"
    sha256 cellar: :any, arm64_sequoia: "51016d9b3f5a23bb18764401c8930e7cb525b6b7dc096b1c872f3a051d4773c7"
    sha256 cellar: :any, arm64_sonoma:  "17b901e7910c9cb49f90d74bd8fc74ebae73944ea1c1e7861e6e3368f7d7248c"
    sha256 cellar: :any, sonoma:        "ffa331612ff3294086cd8561cbf4a6174ba9d39d19f5259e4be1e80c2cdae593"
    sha256 cellar: :any, arm64_linux:   "7521ce4320f21201894d84636cd4f603d920e5779a9e755f299545c086043fd1"
    sha256 cellar: :any, x86_64_linux:  "1425c571bfca3d4b3feec9ea7d2110a80a9689ab4a75247fd9260ce328922872"
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