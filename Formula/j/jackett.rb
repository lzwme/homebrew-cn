class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1945.tar.gz"
  sha256 "6c7bad994af1e8c6b2371a695d4a838d653ef55401a47cbe72fb032a8ff7419a"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2c4792d2424159bc7c3b32f0bd476826c1100e38c041008237153887d7534795"
    sha256 cellar: :any,                 arm64_sonoma:  "e831f7ef13f75daed89e4c93c87bb55f71d32621953443781c871bafee7cca8b"
    sha256 cellar: :any,                 arm64_ventura: "10694a359455cf7ade4126ecdb5876d0c5e368ca60660b8219411061e36d6146"
    sha256 cellar: :any,                 ventura:       "aa6ef60c25903454a4f095e456360a3887d0269e4dbba7eeedb35c978de45b54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50c6817bc244e1a38a3a1cf4f9c701f20add3129af43312f9fe98d977b357666"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7eefd5d16229ec420f575d96ed845892add972d45db94a10acd37b21390f2ea5"
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