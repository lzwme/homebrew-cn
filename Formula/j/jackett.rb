class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1992.tar.gz"
  sha256 "f5a68f08ddfb75fa50c08a27c4d079d3f979afacf0087a63db5f7a1e07c47d5a"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a1c6674f7dd0230af780e1088b8c27d25821b2a8459bac32f1d26fc48215d9f5"
    sha256 cellar: :any,                 arm64_sonoma:  "7e6ad1f744deead48cd2dd58ea8bbd6831fb3e814e57d24b77f19a9187c3369e"
    sha256 cellar: :any,                 arm64_ventura: "beb3eb7b4b9b27bb2c4ea4c5b19c2cfec24bceb28f01b72d3aeb0be3a5cf8976"
    sha256 cellar: :any,                 ventura:       "4238c63e510acddd24614b017e50dc14ef84cf41dfca87de68ab36e4875ed6f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3777a8dba39518a6c21998cf6e50fc90cdbbd42e0bc73a5065d7985ab9174684"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9c0b36fcf359d473d7b9c60c671d59df427b0292eaac5cef682337f835f50c1"
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