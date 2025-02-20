class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1443.tar.gz"
  sha256 "46b5fe5668c73cce3beb95f4f0e67d60be5392c426912adc1096f0b68522b192"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "37eca453351596311c7e7477d05c1846dfed698e9e58a3fd81ea7c2aa94dc567"
    sha256 cellar: :any,                 arm64_sonoma:  "9ec556742dfe722dd65e886d5d26bcb06e5389e7374a85e36b957a23ca688c0e"
    sha256 cellar: :any,                 arm64_ventura: "cd8c81a31c8d8c7f06a1af4aa8e022adbef301c40a414a374164f631e391e991"
    sha256 cellar: :any,                 ventura:       "47f791f45316e7ac7666dc1405af250a2b4509add7e9fc284df3bc539b696769"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9d369c0ad0bab1b14a7c7c1c83fc0ff0337e5dab42acfd3428d2b2c8413391f"
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