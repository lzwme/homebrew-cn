class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2187.tar.gz"
  sha256 "789ac6418e63b3868c73ce94c4c1f74493940283a27f05d412bc78efd9132836"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "975526686c29230167145386636143fd646fb57b2f45a7d74639d6c28315463a"
    sha256 cellar: :any,                 arm64_sonoma:  "2ba85ae74ad16aa0ca6e992099e1df8670f2018c4f8cebacbb91bd448249f73d"
    sha256 cellar: :any,                 arm64_ventura: "986bcfae7230cb232ec11a4ab8528a13272e0a8e5b0c4668bd4c8ace5536b207"
    sha256 cellar: :any,                 ventura:       "111f597dab0f8c550e8d2aecb116aeb31bc381f8318116774c9012e7b7b77c23"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "550f754466165bda6b88ebdbc301580ee755d9f64bbf981af212becd45351c03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09e0b535d73cb2a93201df72ffcd67b83ff5afe028dbd3b8966a745aafe18f8e"
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