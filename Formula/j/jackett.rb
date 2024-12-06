class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1043.tar.gz"
  sha256 "52b52e060e660a27f7be1dfae3ef11fc20858ab89e470d59ccafab7f4c6d9ea7"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cd75ec9c5ef14b9d4463c25bc236abfefdef289fdda0ec49a32c39282660ec88"
    sha256 cellar: :any,                 arm64_sonoma:  "6cca99b52753ec85ec0842b745a6054be17e614cd335295bcc9233ec64c720ab"
    sha256 cellar: :any,                 arm64_ventura: "95c8dacc90bc456dc83c168cbbd9242a651b54841522daa6da108220bf8e31e0"
    sha256 cellar: :any,                 ventura:       "a99acf2f599b520c02e079cd5d1d21a59e9cef451737baab3ff73ee825d81786"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b29c4ec2a11fae858e466cccbafe9fafc775d5af83ef1ef5a909d4ad21e04e46"
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