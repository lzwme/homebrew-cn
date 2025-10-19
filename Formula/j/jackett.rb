class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.153.tar.gz"
  sha256 "19e9772447c03de7e8014ee2e569eb31f0a5001f942af9231f284d28d2425462"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "907a28e02ebf6895e48005de8cc0030b0d2b78e9bd5bfabfbaaaefefaf5ba0f0"
    sha256 cellar: :any,                 arm64_sequoia: "eb60be61fa2a31460f9edc93c5cad2231f588261ef180a215b9d742154ad5230"
    sha256 cellar: :any,                 arm64_sonoma:  "c227a0559f55118124bdd3a5e39ddda2aad18afc3ac229ef3214fc0d0caf06d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6bba374c3739f89343a5fdf6b2348971bafd6e4854008f6f91ae3bcb6a9d3ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0f9c0f520d78fcd770f5444ba7335619452450329bce7503daaad17462428c7"
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