class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1064.tar.gz"
  sha256 "9fca7fca6709e43a84c7060484eae3af102f534ce9a077109a6612cb508f209a"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "515359d481bf1f5a445a23bf4cb5b031d92fe8ff8babc0e17dadba7e61e28ae6"
    sha256 cellar: :any,                 arm64_sonoma:  "398e7c6e947eb1432c936b72f41f1c4e9cf776196e84ff1c22a01f017cc86f99"
    sha256 cellar: :any,                 arm64_ventura: "8ddb750b1d368cc702e4c5cfd4a01cf6ccee6a1f43a241feabfad433bb3d3282"
    sha256 cellar: :any,                 ventura:       "23cf36e1a327143e4770fb91fcec2edfb72d6d2ab1eb24f28ee0b6d403bb86d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74742d4c9ac94fdb44042ae3ea5e3e6df4a9a5c492ac75fa280a38369e8bd523"
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