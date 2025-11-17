class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.314.tar.gz"
  sha256 "b042b66435a3738794d03fddbe6f8569c07dd52ecdfa2a5e7b5076b39d4fbce1"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1bc26844e3266fb4854fa82c662a6f9c85eb05317ca237bce3b2a986057ba65b"
    sha256 cellar: :any,                 arm64_sequoia: "067f7c2d17781f39088612b6e0fc5c1b536b731cdcbdd1678f32a691883011e7"
    sha256 cellar: :any,                 arm64_sonoma:  "4d27b88d788c21cd03ff25d3be1d2c746dc922b72146a8ac91d84911f793a4da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "869651c6e2294287772aa08c1faa83fd390039afcada2b9fde7aea078fa8ff2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4d11a62d49b4033b14a991203096fff1dfb520f9a01c7445e0a0ebe2542a8e2"
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