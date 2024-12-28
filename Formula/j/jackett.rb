class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1133.tar.gz"
  sha256 "abc37455da4adae34a0df629bb615d5baa2509d8e36c0412fbc669f3fa44284f"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fd1ab3699523dc368215947cfef55760c9387c96737317bfacfa3f8f54267c78"
    sha256 cellar: :any,                 arm64_sonoma:  "cf69d1cdb73ae4cc459c0bcb4865f66adb2b061da83da91b9821f8977b954be7"
    sha256 cellar: :any,                 arm64_ventura: "bf934317a5ae037394d92e23ff3f6808dcb08fd22025642b06b0d504aa7fdd46"
    sha256 cellar: :any,                 ventura:       "ee6e3a3eaf96bad5013d8f39baff9937a65177a28f99c5b8ad9bd7d1b00b0ebe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "874231d2c82e01b128315ac95e7c7c7f969d97dc64dd2e271ad0de1c4f8ba9f8"
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