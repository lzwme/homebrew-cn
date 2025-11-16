class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.311.tar.gz"
  sha256 "5365a2c16107582da1a9ff552cd9710a107eb2199c319f18b90ee272f1609ed6"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "edc82479c2036aaa2e764eae88840b6201ad55401da2b0808ca2e9920fc40b5a"
    sha256 cellar: :any,                 arm64_sequoia: "4a973f9deaca9f76d1e5999d3fa10b34270fec9cba157f417c4e81a1a8d790fb"
    sha256 cellar: :any,                 arm64_sonoma:  "0e3eb8a5b3bdc940b55e8bbce695bda8b4afe6df09e816921c761c620b9bf718"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "385bfb76259715833e89769b7168c75a7740c38d369afb242dde0b740925d4d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8428c450d800168f78ab7968b00f90b250115ca8c317c4c6314176d89f907708"
  end

  depends_on "dotnet"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    dotnet = Formula["dotnet"]

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

    pid = fork do
      exec bin/"jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 15
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end