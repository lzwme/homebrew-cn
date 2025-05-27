class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1951.tar.gz"
  sha256 "55b001da20ea9aab6de63e1323830ae0ca7755ff3650d168d8b54df945f1f2a1"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "977131b06e4aace4240ae441d3d67a6f7deb3538fc68dea4e55634a1bcfa2ef7"
    sha256 cellar: :any,                 arm64_sonoma:  "0e4dc0c2c6b7d84e34fd91a761eccc427e4ef693598cc5a7d522f3fc1f88989b"
    sha256 cellar: :any,                 arm64_ventura: "a867e3da966683091f91e5b571df26ec113cdd58760fbe880d173fd03994a71b"
    sha256 cellar: :any,                 ventura:       "bf0ad769a2b6b2cf61a16916f02037e3548db5b55e217d2cede5a93f56fe254b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b60653ee93af380e49b43d341905a8b454a9c04cc38f8fe654d2e3e6f483288"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca02b9a9c7a1c4a1127abdd3478dba3d4667287519f6b87df8990467c7a5cced"
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