class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1815.tar.gz"
  sha256 "76c6ba4bb72f31f10cb2976d88ee2fcd834d641ca3793b16129a91be937b3d44"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dd0909ea31f5f91a9471e2dabd197d4f5c0884cad52f45218faba1a171ceba34"
    sha256 cellar: :any,                 arm64_sonoma:  "44f173f6fb46e74d59fbc80b100a531316b95a2ccfcf6268824cef72efd14ef8"
    sha256 cellar: :any,                 arm64_ventura: "86fb469983a77c6208b01570bb20f6a54109dcfded892836ad35952f21e3470c"
    sha256 cellar: :any,                 ventura:       "451d2b27bddd0af286e9ec63fb34bad493cbdc10e0d38424263278261239fff0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea16cb281ec8f948184de5c827859c7d421ad3d713343ebb596152c9c04f37ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7421da0860ff86928de681bcd0f9ab23d2df8a1e7e78ead5afcccfeb551df944"
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