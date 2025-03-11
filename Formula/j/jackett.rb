class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1570.tar.gz"
  sha256 "dfb6027d105fc8e489475580833bfa1c83be8299999379c790f85483f7e069c8"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2adf3663f06f047ceaf430b9acc03669adfe5f76de6ffd497f7a67a07c9fdd94"
    sha256 cellar: :any,                 arm64_sonoma:  "2c452c6ce46f8d5b91ef11b7237e71ca2418b5c430e2c1318b2e2c339bfe4635"
    sha256 cellar: :any,                 arm64_ventura: "380eea5532e882fb401a49e8daf840d692db5245a86f064871b8df41720d584d"
    sha256 cellar: :any,                 ventura:       "9954108ad37c540ba227d23a24e95fe65e453c6bafc5a78d33c45f4bee825c2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5dccc84a69c616e85b26d7861c7aa9ac2a6e806ebfc35af52deae22216f9f0be"
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
        p:AssemblyVersion=#{version}
        p:FileVersion=#{version}
        p:InformationalVersion=#{version}
        p:Version=#{version}
      ]
    end

    system "dotnet", "publish", "srcJackett.Server", *args

    (bin"jackett").write_env_script libexec"jackett", "--NoUpdates",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  service do
    run opt_bin"jackett"
    keep_alive true
    working_dir opt_libexec
    log_path var"logjackett.log"
    error_log_path var"logjackett.log"
  end

  test do
    assert_match(^Jackett v#{Regexp.escape(version)}$, shell_output("#{bin}jackett --version 2>&1; true"))

    port = free_port

    pid = fork do
      exec bin"jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 15
      assert_match "<title>Jackett<title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http:localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end