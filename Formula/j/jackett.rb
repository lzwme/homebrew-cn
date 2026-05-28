class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1957.tar.gz"
  sha256 "3c73f65939f399d2647c36f6069889bffbf7df7d8bce91a20592d25ca93e9b12"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dffc9eaf7b344cd5e013fc9571042f55a64c6f7b4b0e496d536c2d1d0f04bdf0"
    sha256 cellar: :any,                 arm64_sequoia: "7303a543d45985518e0d2fe2e9a44aa11ab7aed0efe18433def67b158d7b596d"
    sha256 cellar: :any,                 arm64_sonoma:  "a483f8216aa11e9e8212177b7096547609e4cb85876cb274ce05c1b28436a5ea"
    sha256 cellar: :any,                 sonoma:        "d9951785c13c1b0ceaf3a107af2e34fe93e65e18ddd87ab0733a15312b51be48"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94abd67c0e081e0a1b73b4c41e9a167000f0c9a73b04a34e0ddb67dcf00f6a45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f588195ae5dccf228e0530823f0e5b0fd492286b747f04e99bcb10372d60dc6b"
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