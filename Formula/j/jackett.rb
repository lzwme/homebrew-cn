class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1615.tar.gz"
  sha256 "2c81f04cc48e795b559f8b769ffb8c5b40385d3b715d1209e95de4beb2b37dec"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b5b7f3278884c449b91e82aa94a42113b9b3a1f3fa962c31464aae160d8df064"
    sha256 cellar: :any,                 arm64_sonoma:  "095834bf6f91be6040573cc0dd37ff82f29616af9b6e95ffac637f09d78d7c48"
    sha256 cellar: :any,                 arm64_ventura: "fd3f64b22d01df68689e3c7315c72f692ecddb1f1f5586672dd3c56e90001f12"
    sha256 cellar: :any,                 ventura:       "cea9359b5d9ec2dd03f5dd4b8dcd6a4bc6076fe9b883388b9b94821c65400931"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "662d13453bf92960853bdcccfc89af82d49c779aa618d023d42db0969b403d8f"
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