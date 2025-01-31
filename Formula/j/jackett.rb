class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1336.tar.gz"
  sha256 "624e5d9ab1843a12299fc2b3425bd35be2433db07cfed1ea81eb3c373b345507"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1f075372203fa1d89a873fce5a6c4d4a1f23355c3139a392fee675d4cbdabe30"
    sha256 cellar: :any,                 arm64_sonoma:  "70382751395b5894a56b70d14d0c832d2f3c1ceac95d39c458d9335d927ecc32"
    sha256 cellar: :any,                 arm64_ventura: "edeb3dcc456e78bc70d320af4743a2e7c45bad64a56f20d24990de5e5c1e1cf2"
    sha256 cellar: :any,                 ventura:       "a24e81c4b0872a56e1f717829f68db6de7e38580e68b8b4bb2f8d00d7126b175"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2428a99c478bc398dc65f0da425f1f63dc6eb8c24febdd16670cc44f2bad9d52"
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