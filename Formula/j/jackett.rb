class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1023.tar.gz"
  sha256 "6584da271786c879fa5785838d2b88897e76990d0efb3eb579ccc6c4fa8e101c"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2633946601a2d026e227b2219a9baccdd6792fd14f12eca945827d91616d59b0"
    sha256 cellar: :any,                 arm64_sonoma:  "c0126f7617c86f28a8affa04a13b56df8b3dbe247ad2e2b74b4b3039d76b4693"
    sha256 cellar: :any,                 arm64_ventura: "df971f8edbfc5383b77973832919fb39d72616c584fa80ba102ac16f087e1b07"
    sha256 cellar: :any,                 ventura:       "3f5cea2c31e19296be462ac13d9be5a0c32c91c3282623e59b9341beff63373c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "603373120b414a81d908c4a46e160c68fffe466aa699b716de48f8b5977e6de3"
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