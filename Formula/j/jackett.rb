class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.356.tar.gz"
  sha256 "7da77277bfd985fb3fb64281d49c2635c78ad68dd2ea932fb67d1f2cad9424d1"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b944ecda8e7b791d7e9ee7f9aad9ba89b42ed47b1935e8d04665d46a619ce063"
    sha256 cellar: :any,                 arm64_sequoia: "cd05eae45d4835ee5aeb16e7fcf81f4c64be35faa2cfd5b3896c93eafb6d552a"
    sha256 cellar: :any,                 arm64_sonoma:  "486cf9c3cd96feac5155f9990887239e1a0395c4fed329f44eaf649cf6b5e093"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7657cd3417a99edad26078ac05bb0b9ab1b0971d5715d48c6b08dcdb2f1c4e83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8277ccc97027db52a78b34d0ae9f02dfcd439738c73c33b7d099907f5245ddcb"
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