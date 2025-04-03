class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1719.tar.gz"
  sha256 "cc5b1173aeb9f789081bcb1fbe640e7ea448924785e2ba2ba966b9412f80779e"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0593c6855d6d45c75299fba799cd278f6e246510b2f347a769edcbf298ff801a"
    sha256 cellar: :any,                 arm64_sonoma:  "79eb69d4f058f3ee4aa8e81b026354182d6b29af8a3e228c576e65884cc5e7e2"
    sha256 cellar: :any,                 arm64_ventura: "6cd5376ca1e26fe1c4ce078a6cb1894168a8a7ad61d9931001a56f3d2a14ca7a"
    sha256 cellar: :any,                 ventura:       "e50977118b18c1f05cff87e3eb9e3ca1cf9ac020c6a876fc05b028842ca5b3e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2de0e9265c2d0f2781b75442f3bfcd1b2d6f878f63a5741bdb95a7b9f89f4d4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7842ee459bf71129d6574485add0d09b8ffa8b17dfd59fd5ade6d871418d675"
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