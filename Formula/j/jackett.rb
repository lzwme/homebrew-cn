class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2440.tar.gz"
  sha256 "851474a1d554a0a8b2b46cb4ad694acd5a8caa0700d4a5b45a30c97d2e02b31c"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ec52c51acf60b36f93a8c55212b1361512d4b162335672a567da26abef24234a"
    sha256 cellar: :any, arm64_sequoia: "ad04c00f6ea5e16b9b08943557e56f815090ea1f6b6d564c2f5d0b4eaceda3d9"
    sha256 cellar: :any, arm64_sonoma:  "edd97fb4971d21a168f7ab3b604c79f22e45289e34d235f2e8648068eab696bf"
    sha256 cellar: :any, sonoma:        "32464919486f513cab7682dcea1796218e873016d7c95a3d4146ee5e2dd8b8d7"
    sha256 cellar: :any, arm64_linux:   "a7db3939dc7dd553c226c8a330e1d4f4c6b9a489d7db6248342417be761bbf5f"
    sha256 cellar: :any, x86_64_linux:  "26ab076efb27e701a21d8d445ade87488adafbbc862bc89f6313255b6b3995aa"
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