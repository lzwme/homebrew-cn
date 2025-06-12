class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.2008.tar.gz"
  sha256 "2b17119740d8757d178276f726b692c2949ea74e1ab1384cc8435a1115485de7"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8b45f2a7be7183916b162484913fa6a1cb9d8b1b95eee8d567f2c178e66fdcf6"
    sha256 cellar: :any,                 arm64_sonoma:  "d9a3647c77064b7b86b992327c52672abed7924024ea42cfc3728d8688d2f187"
    sha256 cellar: :any,                 arm64_ventura: "84c6f6d091b771b2c8099ff912bbd3f2c52977a7a3b38fb4537cb73ef5ddceeb"
    sha256 cellar: :any,                 ventura:       "aa38d9a02928752b32585ea16d8961be6980f49ea2388126f091f6f02285c690"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "680ed413e8836a0a01b0650dfb21638be583f488ed5fdde65b638cdb9793fa8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55a237a76c27b982a945165db0019fae5ba6abc02377f3b92f8291ee0612a7b6"
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