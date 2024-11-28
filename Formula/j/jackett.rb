class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1012.tar.gz"
  sha256 "8e199ab9f11b568984cf19f3ac423efef2044c76b4478cb96e42eaedfde583d3"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a6bcd81bc8cb7e8318accd8ba49619e08513ab33dd008a2cec09df65a4a29937"
    sha256 cellar: :any,                 arm64_sonoma:  "f3be41f6787df5bb7c8f1e732b6f1b02514f8baa375a45021253b8be7d6f857e"
    sha256 cellar: :any,                 arm64_ventura: "664210873d861439f507d502bb89f042ad00b6823f9c4c414e3c2a6a72706432"
    sha256 cellar: :any,                 ventura:       "996a7df2a9d3f23a7601e24a079f7c31f4d392fb4fb9cf2df4673ecf00ce714c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1dafe0f562d9f6287fbad0cc71f0b3c7111d2f96f620725c75849d93a055b7a"
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