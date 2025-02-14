class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1421.tar.gz"
  sha256 "eaa5c2457b26036d10d8e73bc8d70d7da0c254da00eb40b14b11f4dc170002a7"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dd94d6e0337ee6a6035a633e67bb6b9c17f86d410429755bb2515ad33a011599"
    sha256 cellar: :any,                 arm64_sonoma:  "db5554969b3714e692a86852a1a1f1c42d52e8aa5ca6886d1d370b51857ca795"
    sha256 cellar: :any,                 arm64_ventura: "b2a72a6ad74167304a15939f7bca12e8b79d35b2612b6462988d05ac7ca0b0e3"
    sha256 cellar: :any,                 ventura:       "12fe09bd755ab8d760dc37e3b4102472af1e5b703e7d2fff3e446458e1677870"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2de5c4d46e643ad8c9eb591882249c0ddfea646e060be63886236b8681ef1f4"
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