class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2451.tar.gz"
  sha256 "fa0943cbb8d7bc5c07c7e0f54d8e2aa0169a7392f2c2c25c9eafe45549cfbc12"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3aed2cb9efa39cdf420fe576f54c37627e54cb78553763fa22e4b9bf5c3a82b6"
    sha256 cellar: :any,                 arm64_sonoma:  "db15ac965fa5b59a8816b07708b7d942c3ab51891399196d8ee3fe9b2f01a029"
    sha256 cellar: :any,                 arm64_ventura: "28185a68f11787710c1487864fd6dd073e929766820850683680d107e209ef41"
    sha256 cellar: :any,                 ventura:       "34dec64e52da14554aa40161861dce331a7f0e6b93870f9da240d1c07575e092"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f03416b7778c8738ba998797a531dc56bbcd00f58af0f9eb8bf881acdf0824f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdf0136aa90c8dcaa4d68e28d95b6587eb900791938a36d7e3e30d2e0f408dc5"
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