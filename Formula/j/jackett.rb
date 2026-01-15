class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.846.tar.gz"
  sha256 "89bdb8c6a18a329281152b609e1194249670e85328eff7423feb3d8e76df1389"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9239437a7983434217d6088079b79d7ae376bb63ec5b0d67303d93bc8bfd4995"
    sha256 cellar: :any,                 arm64_sequoia: "83aadb1094db2c7dea071a9c433bcd583bab1841b4fff7d0ebdf0d07e65f7423"
    sha256 cellar: :any,                 arm64_sonoma:  "7a0deb93b22597c953a2e6a86ed438b7328cc2434c9262b74a922f08098d9750"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7a1f6c5b639aa206c3dfe4edc4b9ad1b55dfd47b75ef971ab30fa1d868b398f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66f10be151b3e8c58c8aa9f9728bda3e8ee570ab8f92aabf264ba8f05365d2ff"
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