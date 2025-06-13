class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.2011.tar.gz"
  sha256 "cd0733bb515e9cca772ba7753bc2f424538f44a6d726b39d8eaa9827b49f2ee9"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3f36312d5c30bbe466a8961bbafac38d3bdf025072e3c72f5342ad3eb6548b7c"
    sha256 cellar: :any,                 arm64_sonoma:  "c3808da17a6e58f28e0315c8f4ff59daeda380fb6f8012d333f6458b824fc2da"
    sha256 cellar: :any,                 arm64_ventura: "8ac590478260c26d075be56099d4f6becb2613eee42ef1c96c415ed37d726011"
    sha256 cellar: :any,                 ventura:       "8d5c440eef6879f63efef49a7fb6e4a144a35277099fc161d1887eac2b18f9d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "098c4f1ac41254fb4aff5712579efc9fe7196fbf988b06971e8d05b3c9e3d21d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e699703141f7da6026d4bec97c9d73a5f48eb8503d8838ddb7eb77df1b5e89c7"
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