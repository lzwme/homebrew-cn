class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1027.tar.gz"
  sha256 "6ddb1c2fe24745833e6823a87158bfbc6f5be6ed7488258f3e5e435a80914353"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "244692e4d32488aa624c1296178eef0cccbf4780fd3ad40c51658bba8b4ab733"
    sha256 cellar: :any,                 arm64_sonoma:  "cba2a2ae6027907607f62ca70a866983dfc95b660caf33a856b435901dcf50a5"
    sha256 cellar: :any,                 arm64_ventura: "825cd441e6840c3269fd522ef16acee8b0609c4b5ca7739a0077dd35f4a50cd8"
    sha256 cellar: :any,                 ventura:       "323fdbea8245239e760620e4c1451a6a6b0e7b328eb7f675efd7361abe834089"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6594a64709ea4ef4192123c19d5d00fa805123dd27d5cc69aa63f4c4ccd2f86f"
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