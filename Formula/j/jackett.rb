class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1730.tar.gz"
  sha256 "c7f9465ca26f2406ea703c9a6da12c74c690a855c98bfabc343199767bf67a0d"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b7d8081c1b22a56893c3e53a2c86c53e9afbdf84a8c871d388055a9c43a2fa83"
    sha256 cellar: :any,                 arm64_sonoma:  "526d06db13499d26f37010a5d6f63d7e5f309ea36dcc092b4f9568154590fd76"
    sha256 cellar: :any,                 arm64_ventura: "e08f928cf5770fd970b54489aaec367f8e6d324ffc1b2598dcfc6732da947c18"
    sha256 cellar: :any,                 ventura:       "914bb2314b1b43014d7e70e34928fe46f180193210d52abe0586a2bf9a15a297"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "904b7a09b629b85c44203b67a214c0bbb8877adc29c73f62101faa730fe73db2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90add5d95714a33349b293d8507f8460dbe06480d3a900602c146325dbe3d817"
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