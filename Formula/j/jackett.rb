class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1466.tar.gz"
  sha256 "6e9a9c21f75bafda99bff0ec6bfbc73ca53e34c929b4a2513b0f69df17a017db"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "68f985b5cbfa954312e7e2bba2db53f99f894020874b5f27abee6e96a9ef3807"
    sha256 cellar: :any,                 arm64_sonoma:  "be714a389a9338297474a83a5e680238b381a52768617188b5407b531529ede4"
    sha256 cellar: :any,                 arm64_ventura: "2083f753e52096759fa6559225c466cba3317c8767ae38017835056ca20d2af6"
    sha256 cellar: :any,                 ventura:       "1336a160ff4532e39535bd2d2108298d65f9fef75811e78cc059f4521b300cb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7064a4d4416cd0c9cd51160b95b08952d27b076e228fa28807b10ff7d85a0ebf"
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