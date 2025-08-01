class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2213.tar.gz"
  sha256 "3c410c5f58f716ce3c2587a704efcf8080040a41b4be341e7b5d0e44feac8c87"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5997e09a72709bd3cf425c12a65353b3b86212158547cad3e71fd9c722b756fc"
    sha256 cellar: :any,                 arm64_sonoma:  "f1687c3056549d9dee782babfe133a5b3653310b763588fe428ad09b19ef79ee"
    sha256 cellar: :any,                 arm64_ventura: "30b53740fb0588d2c909142a962553f01d2759b74055b835cce1263055ed5c38"
    sha256 cellar: :any,                 ventura:       "a883cfd9f638a2500f5b81855ef63498413d6434534f0862a59e1101353d0382"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4abca9f8099da6fa4f1c9c898ab3deb64158157dd473ffd0d3ec8954b7d2c7a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ecb4e88a20744ca3a3ee49b1b45f1835d0173dae105e07aaf43236f9f29bae1"
  end

  depends_on "dotnet@8"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    dotnet = Formula["dotnet@8"]

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