class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2098.tar.gz"
  sha256 "e33dd8091046929032e959227a59de8d73247167cace9634bc752c4a8fa36659"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ce9e8ec9c30b4b14e64ef341436f4408b4b59eb36cf4421d68f3b21cf473a4ef"
    sha256 cellar: :any, arm64_sequoia: "285786dfa04698615a8f4de45bb53f47ee80c79713daa62aabf5d88ed19ce1cf"
    sha256 cellar: :any, arm64_sonoma:  "eceab9ac776d0a041c9f4fddaddf8ce68f99ba5dfadf21a1bf8fed5b8242cc41"
    sha256 cellar: :any, sonoma:        "d6cb6b039baedb109c294cfd38d4944d38ba0ea8d299ae393218e4a019b11190"
    sha256 cellar: :any, arm64_linux:   "fafc511122a7f319a980670c6d4a104b6a9ed0ef150968119c812307501bbf50"
    sha256 cellar: :any, x86_64_linux:  "8de771389056240b99189faee66e65d24766c37e4677b14935c79a4a7a15659f"
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