class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1740.tar.gz"
  sha256 "cdb65935ca84f3eed457d3f8769cfcd36d521e994bedf2db59e4701916bd8c2b"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0d1ee81300a17fd9ac04a73a7c1e34636e08006f4eaf1ff2b82afdcb102c86e7"
    sha256 cellar: :any,                 arm64_sonoma:  "3e1446743781552f14f35fe136aefc953561144eae74188b418d157e6fa0d141"
    sha256 cellar: :any,                 arm64_ventura: "cb2fa1453b5816db400a2d1955ada80440e592a2fdd77a51c3d4e96d7c212fb8"
    sha256 cellar: :any,                 ventura:       "494bf2b927c7a08bcf9157795d1cea97dc10f92490ce97598e9ad1b87aa10a9f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b2f7787d4629f952419bc9cb57e52040f1a54da772a0d690d2f32b230bfdb36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5178063f27a2f9c4038b04ea4ddb3bdc72a8ff7502cd93a42dc9b05a03331f3"
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