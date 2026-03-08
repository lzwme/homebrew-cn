class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1307.tar.gz"
  sha256 "4029cf4e3f87eb0cf2593c51dcc71027e41ff1a7d08714e5d1482852bc0c3179"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dc4886668bff96769103539277adf09800c4638db37e04ccef649bf9f8058bf5"
    sha256 cellar: :any,                 arm64_sequoia: "837a4445708573b9ea6cf42e9f638a4f3c8e411b61d827d03b638faee822c67c"
    sha256 cellar: :any,                 arm64_sonoma:  "c75e6f3e26ae362fac2344cde4d6f772b38330dc60007764fd42c420e5e0e7d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c882e3d5b1719e013083dae082d3ad07a441b3c1fc03e10fa60a2bb35a3c898"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7a7cf339fd2f5cf979d53035daca8d8035aeacfc00ecd1857a6c574f454b1e2"
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