class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1310.tar.gz"
  sha256 "035dca05a1564cca7d3828fe87cdec801c5c44f052f3540d396d86464f8dbd8a"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7868f5ad0125ce0c7734c780e14f70165650e903657878ebf57154503902dc82"
    sha256 cellar: :any,                 arm64_sonoma:  "5aa596d59b2c8059f83a1ee5f7922e4f2e1c32264f9d1a63d701f0a17ef262a9"
    sha256 cellar: :any,                 arm64_ventura: "abe76159e786372fd2820422ee5e38f31b157b94a530c538370cc1acc0fda391"
    sha256 cellar: :any,                 ventura:       "3b3e75d4656645c0ec9c3471d3709cd3feb086285710c09e8a6c5e626e7446db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a0fdb78390d61c987650c3bd863fd804d8bb59e5f488ef82dd24ae50d1872e7"
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