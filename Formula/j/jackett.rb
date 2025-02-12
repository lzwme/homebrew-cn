class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1404.tar.gz"
  sha256 "7db20e38026f27be8124cd84379e61b6872a96beb15e18b9b6e45bddcfecb599"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6c124f2b444f9efcc8f0aaaef79f83b5fd9463681f7298a1c7177b5b2c0a36d1"
    sha256 cellar: :any,                 arm64_sonoma:  "62e20b5078247a0e084b526858cc9351919af45ab96297546618bad0ec5c8e57"
    sha256 cellar: :any,                 arm64_ventura: "a282a25bc55756342b91777ed8e46021d738f075f576e3259efb7ee55c267aac"
    sha256 cellar: :any,                 ventura:       "61a8e44b3fb7e748b43aac2a32a0edcf34e12025947cdef11a233b82602670da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afb9e9295ee5cbbf88440a531d9480fe68e18d5c09e22bfdc8e27c858f45c063"
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