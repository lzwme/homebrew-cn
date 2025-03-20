class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1665.tar.gz"
  sha256 "5b6c46a4f8e2dc0a7e87cc8bd96752d7a07e172d15b8503655fa0ff664a5517d"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "590c6a9b70633a05995a8cd079dece6b8b83de51a5d7ad8b94936c1d93f0014f"
    sha256 cellar: :any,                 arm64_sonoma:  "a476239078e67dc34e813731d2c5e491a61bf38264988b2ef523663570854638"
    sha256 cellar: :any,                 arm64_ventura: "51626df726d034624fdef8220eeacfb23ee39cac6bfb0da4464bee4cfbc062f7"
    sha256 cellar: :any,                 ventura:       "2baf22f433eb494bc4613994aad4efe5c7a35e80db7b02f22365a408c9c97dd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e97c60f726c8007137fa61ecc33b639e8cdea9e8f5e2ae0367f3760eec297f61"
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