class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1055.tar.gz"
  sha256 "0981db60e0da985f6dd9d03d4e886f1dbc1456ca40378acba7e2a9217948712a"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3a527cb5852ee0c5c3eb0f1a2c2abf3f2f828c882c1aacb8ef0870a67314f522"
    sha256 cellar: :any,                 arm64_sonoma:  "d5c1e1915395eb4c4c62ae67c8419c943d0a28d6891a37269bea6453c95a9797"
    sha256 cellar: :any,                 arm64_ventura: "daea2102cba492a46eb122e715fb5822b44224a1f416db9bf3b520fb54f2f5f5"
    sha256 cellar: :any,                 ventura:       "a6d0843d64a8b7ce65be0c77ec7ba5f07c1151ff7300fe1fdbd1b6f042c8b4ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d93349c8e553bd3c7088d4bbd23429d739f4560ab012848b6b327b0f6a0d00bd"
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