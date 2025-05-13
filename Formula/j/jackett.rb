class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1891.tar.gz"
  sha256 "287d9274910746e71913744114a4e95df75596bbaec12e7121a6cda90d3a1f71"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "747dc4833dfe3214edd06717a6daa4c3ee41f7fe8dd753982721d24f2a3ec603"
    sha256 cellar: :any,                 arm64_sonoma:  "10982ae966e36f77a050d171c2822b2113693ca4e48f7fe7dc3b14018071029e"
    sha256 cellar: :any,                 arm64_ventura: "346be76e9934927094dc2f993cf579ef947a8ddfb54426bac738d04d183b31ad"
    sha256 cellar: :any,                 ventura:       "21b3944e0e3948150032ec2b088f379a2e66ee3397cffd89c849d9dc3733df47"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb689850859389cc975ba09acf247cd2779d6560d280bc2f566adb69c248fb58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ff3fdce859f6b719e3defe259eebf8074614d6e75cab0b75fc54a2d940c1a38"
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