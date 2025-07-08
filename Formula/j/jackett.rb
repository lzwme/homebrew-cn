class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2125.tar.gz"
  sha256 "5457e7cd52fb67ffca7cdb818cda8333539468e8a80ef759a2e6e88c08dfb43a"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5a3ce56f8a30c9785e47733f5769b5121ed860c4c336afbcfcc263a72b33cd4a"
    sha256 cellar: :any,                 arm64_sonoma:  "07b4debecb47400e7fe7826c5b949f5b6f4b8dd0abd35c996313d9d83f762207"
    sha256 cellar: :any,                 arm64_ventura: "90b8daf8a55cb9d216a881e5f72bede1e77b5e5495cc224a67a2418d3016dba2"
    sha256 cellar: :any,                 ventura:       "7b8b475fdbe049f59e47263786d823c14da255e41dc73b39a9f74b2cdfca1c9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "970a18b38b2442168ca5cf66d0f4389bfb158c51c8e08be69e817baa411ad98c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "209322495f855670518f3a7c2b1dfebb9a059397df67a155c811da2474a72497"
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