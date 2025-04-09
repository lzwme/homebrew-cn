class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1744.tar.gz"
  sha256 "e8d0d0637af8d8692610e2629eb4422fdc716b304461e3b1768fd5c26faf5571"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9636ff9b0b2aa884bbd41b10587b77c8bfcb7b981910c5e64f3faad973f29521"
    sha256 cellar: :any,                 arm64_sonoma:  "3162c24201f45bc3ff2edc219beb942742d747ace719782c249b9ec908fd11b5"
    sha256 cellar: :any,                 arm64_ventura: "a90c41101c0ce0121681910ce9431f68f3ddccb1a5f88b1037c15e5851b34cce"
    sha256 cellar: :any,                 ventura:       "bfe1519b081f78ef8110e385744ce4acd6df58de6a6abdfb36b968fb93bf40be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2af734ef0cf77a2f4d41c830fd1b15d92f3a6734552309d4730c7d9058be335f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f730ab1d83eadc22589e2b721b1ab99ae5d5f7f37adb7f8c7002201d18fdd449"
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