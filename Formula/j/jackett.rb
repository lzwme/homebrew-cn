class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1033.tar.gz"
  sha256 "15db16040370da59893fa49308770861f6381764c8df153c46ad444d759f9a09"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "48441918ef79c61871cc251281f7c4a25d144310de7806914e26b6f26a4ab7fa"
    sha256 cellar: :any,                 arm64_sonoma:  "a4436fc852f3c1bbf3b1a718e339280b953c76ec523e90f098d164e479e917a1"
    sha256 cellar: :any,                 arm64_ventura: "f2e8fe25546c0db32723d60da17c809848d92331211a990975bffc5e61554a47"
    sha256 cellar: :any,                 ventura:       "0b883577c1552b4824f84ae59e065bc36d0b2b224e6546cdabcc2dd520cd1b03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28cb9436c66895507a1beaac43c0e597df9740988aa9680edb83ceed371334a1"
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