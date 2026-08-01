class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2304.tar.gz"
  sha256 "c7162dc6dd14e8f19038b7cbf74ba43b609fbc1bf6f1488fc119dddd65958b40"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6578f7862d66b8d529d9acadcdcaa10bd7df93c8bcafaae3aab28b7a9d7f1ece"
    sha256 cellar: :any, arm64_sequoia: "343254d000977374355d271ec3e4a1f140546f0b5e00c24d9688d8ff8dbd1a74"
    sha256 cellar: :any, arm64_sonoma:  "8ff8999e87f1ed68997bef98b1016610e727ec9fed93451bbfcd8b9490a13efa"
    sha256 cellar: :any, sonoma:        "b9e13c0d37136e8e2b81af6b016ad5727a086da3af74fb0857387bba47787595"
    sha256 cellar: :any, arm64_linux:   "d78700b3f576a62447cbdf89caf9ae6f02d73b12111ff6d9054f6903e4d7f66b"
    sha256 cellar: :any, x86_64_linux:  "930faf3c09b6945cdde5d4a65071da55423f99b6362b8e9ff2ee0a5b7c7df9db"
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