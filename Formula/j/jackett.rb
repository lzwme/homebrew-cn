class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2315.tar.gz"
  sha256 "c585ae824fe67fafd4efcbfcd1774d3a55f35a58e5e1891bbcc15e2a13061c9a"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b9fdfe162035ca9e10fd974ec56f7b3f2002f655aff000bdb2cf246d8a000194"
    sha256 cellar: :any, arm64_sequoia: "8c27de52a7c9b7fcc4512b3d6ca1d14279553ebe7188a8d5bc1641345d892008"
    sha256 cellar: :any, arm64_sonoma:  "396ad23f08b77525e361e4ca5e91cc6d1be914993dd8573ff9909aedcbe2a232"
    sha256 cellar: :any, sonoma:        "c498cad9b5256d661195653000e810bb45d256d53ae213df059c21b6a071fa15"
    sha256 cellar: :any, arm64_linux:   "fcbd6b8c534cf8374b47d7f65421a81b40b8c15b20150694bf9a39b340b71ffd"
    sha256 cellar: :any, x86_64_linux:  "0c15942b93d40b454e67af73c65337e47ff5520fe0a44cd88761395cc35454bd"
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