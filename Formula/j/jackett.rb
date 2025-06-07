class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1995.tar.gz"
  sha256 "848b6efbaf3fef6e449b1127e270b44e4fe97f9f4296f9878570c9caa615c610"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0fd116d2327e7e12364b842ff4b28cb7eb86392a4668d408d161e1be48edd579"
    sha256 cellar: :any,                 arm64_sonoma:  "4adcbc208db2498b6cc1bbfa279ccda62ce84934d3fa356388bbe998afc9a095"
    sha256 cellar: :any,                 arm64_ventura: "f6425222491e95bb403ceba5e8083c9b3141f15c9a66f906b3d39079d15354a9"
    sha256 cellar: :any,                 ventura:       "d4d7171e9e50594ab7c558ba7ef0d82b68b2a87a2fc9bc55608c5e88b74ca6e1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "811929dd5207dfc79c44fddcbe48f6625b47257d64b3e280e974e1f48c83e957"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2dfa0b4891b3bada179de4053499285c7ccd839c5929032f7c166cf8b002f9dc"
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