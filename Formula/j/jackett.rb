class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1458.tar.gz"
  sha256 "c21d185b95a3692d59a83d8fb997ca3106007954849ce98919798dd97fa0a836"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0a223c0d6773dd0943951c44a3832d15402a7a30a16b86d8233b7bb4ff895f55"
    sha256 cellar: :any,                 arm64_sonoma:  "643e714d4a921ae56681362eaaefa6f3e01074a307ec14d8c7bb7d25ea7518a2"
    sha256 cellar: :any,                 arm64_ventura: "a0f1532d167e9c96c9057e4d8b7bc9ce1926a98c51338b354d21ea21b589ec37"
    sha256 cellar: :any,                 ventura:       "4b8e9d6e239a141529bdf7b8693fd4f1a3d849e46f2c0895f13dcbd50a398d24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db15c22f3e5a14a9e4d9329b4a0677f216573c166ec262a30ab5c34ab0c181d7"
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