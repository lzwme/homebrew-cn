class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1465.tar.gz"
  sha256 "f0b1fb7d1fc686e0a9a23dc63f84ff9dbaff2f61b04eaf28b978325634c47be3"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "036c3f355126936d97291a6c88f180a725e05a120106f8b017d5e7631687c8a7"
    sha256 cellar: :any,                 arm64_sequoia: "cc222caf4948a7e7ecdccb3117a89f640cb08b281400708b28ab43df12943a88"
    sha256 cellar: :any,                 arm64_sonoma:  "a321f8ff6fb7aa851bdb3cbbb0e8c37a5910ff8ea8e2aaf247cc99b80549d12b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f11a6d3fdb457556312c39fbbb21a6c65545cf777665c519aa0ba93209bea68d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27bf89d5c7748cad9d7676e6095fb262dd343569e2aa2d0c86cf7686f09dcf8f"
  end

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