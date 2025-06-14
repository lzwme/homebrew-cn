class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.2015.tar.gz"
  sha256 "8e34e73e8291646b3152f5fc0ce8f3e7fab824d9e694101c4b62321b93713a3f"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "638e6775ebd53a38252a6b69b31df7bfdf51dce2f9f20373c1b4273c831adc2b"
    sha256 cellar: :any,                 arm64_sonoma:  "9013aa5527f87c7d37a31dc35565da3be5a97050f67296225c812a485fbba9a4"
    sha256 cellar: :any,                 arm64_ventura: "d8e3f4545a291b63a821e4a97c197fa34ad201d0f43916ab94d9b429fbd3d73a"
    sha256 cellar: :any,                 ventura:       "4fb61dc3e79c478b0ef5bc13370129f8a7d1a4078fa3e0ba8cd94bff3c0edee2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f14c7565f80639a135a6017b16137b62b459ce1f49ba23b9b7c3f384256d30e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14a69bf97e58dcfa6888fafa8df5eb66f895c1f719f27b791a0b190d3be18f95"
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