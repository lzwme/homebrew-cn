class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1438.tar.gz"
  sha256 "84b7cf10b33a45cfe700e780e514a8c24cd5b693c4c63b813bf04ac36d6c94d6"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "30b8ad0a841320a4e7e59ca9233b2e17b2c3b7217326ffa96d16af954e22553f"
    sha256 cellar: :any,                 arm64_sonoma:  "b95cfa6f54f939f9ba32c32d5fa9871f06ce30772b75ee1937eef751dcb31600"
    sha256 cellar: :any,                 arm64_ventura: "2f4f8b67db6cac17ba4ec21350ed173818af90e3903e08a7cb19c76ea7ed725e"
    sha256 cellar: :any,                 ventura:       "9baec468d54c991138e98191a2b15d0c12567787b0f192e8e0770d3f4e05e6e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85533b5a9731fe2c0bc740cbc46121de024fe0c2f3c67202f06525ed073d12db"
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