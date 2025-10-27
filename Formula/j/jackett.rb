class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.191.tar.gz"
  sha256 "db997ebf7f43b5c3973277840efcc0ff93ff44d0bb5bdd7bbd49c2700da0f2e8"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "947c4280eb0cccff54ef30f8aa4c13b78f1a9f145ffb1b3a28cff7e5e86d2f83"
    sha256 cellar: :any,                 arm64_sequoia: "d03999ca9aae356d47bde1177ac68733c3eeacc7f12a27773287c3b262f6d4db"
    sha256 cellar: :any,                 arm64_sonoma:  "a5f3cd7bc0f78f87fd6907a36b13d80bcdb4c174f7015a904d590792d95d4463"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f7c9248a0f6762378f946ec8657ad01e2c0d6f4817610c848217af20fb83d4f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99d65d09f66b2eb3bc25f779936bda55e5d88e2cb33b1d62b4860ba9fc4716ff"
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