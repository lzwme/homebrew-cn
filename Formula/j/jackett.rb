class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1900.tar.gz"
  sha256 "08e4538f480a70b4e17f967ae973b763c9dee1a217431a8bcf1ff7da954a0827"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "65341c2ef7b5cb44a95fe24d016125dcfa816e13d56176dc705c35853de59a6f"
    sha256 cellar: :any,                 arm64_sonoma:  "776a1214452e1efda935f7fb884f90b42361bd14831573d4af4b07e9ddad5c3e"
    sha256 cellar: :any,                 arm64_ventura: "d811ccad64985b595b5401faebdc269400ec7b9be9c54c9b6611b8fca58a0059"
    sha256 cellar: :any,                 ventura:       "ebb75f52465ca092fefd07dd6481ef8f5b98e61973e5fa20cd60fa5b9047da96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cce5f086f80b4a69f12d3b6a179c4e388a3b5076d36cc28aa17371f343f6f6c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e24ca35afb17346d309b1fa1c2c87e6e4b664123bf35b1d382e7bbb92cbcdb6"
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