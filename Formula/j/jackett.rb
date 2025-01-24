class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1296.tar.gz"
  sha256 "deface8f96fe68e83b145010a4b77f68870b58fb0acc9cb32655f47653672145"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cb130fbda337051047758f037c915a98732ec65c9597ab20362ca45259c4d491"
    sha256 cellar: :any,                 arm64_sonoma:  "c7d36dd8173e1d20f5a59edd6c90f306a861b30ddac29677ac51d5fa79b83d25"
    sha256 cellar: :any,                 arm64_ventura: "c25cea51ab7447b7e2a92b4480579fa4919634b7c8a51782b6487a9d17575621"
    sha256 cellar: :any,                 ventura:       "6aa4fc98e414656ef05b270c86b48cc14772c02ffee2e3831ebb1093081d38db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c83380130dcb979c9466c208f50a3f2bd34c2f8fa4a45fbcf8fee175e60b6af8"
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