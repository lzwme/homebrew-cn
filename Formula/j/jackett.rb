class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.2075.tar.gz"
  sha256 "1e1b4e36e2ce60b995ffed0832063af9307f81d74c088f30cb807a3cf9a0c37c"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "51012c34680110e4afec0d8bf9fdb7b199dd74ee41238203dc584684e096504c"
    sha256 cellar: :any,                 arm64_sonoma:  "716dd643eb82d2fbc1278215d471c87faebe0db32a78053ef9fd59cdd866b290"
    sha256 cellar: :any,                 arm64_ventura: "1f01ac7cdf83b99c99a61e521f37eefe19c21f831302ca1dc0de806fe8b4e0bd"
    sha256 cellar: :any,                 ventura:       "136fe428d35a8160c78fe6c0707f0c6b0cb841d4a1e3a4d2d48533c3117e0281"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e274785fee0480be46e86e3be5db4d2db2d87070ecdfaf7170efa8e7e48ea64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a79608fad28bb39ca821aa792e31668c98898534b1c1494d08bfe1c45d968d24"
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