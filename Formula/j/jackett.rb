class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1634.tar.gz"
  sha256 "d8ba919e7b5fa4f35622c3f6ac91fb5e134627795fd81aa109a239792ac3443a"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "05e891df4517359d0a3b2a82757b784e0e4ad57234c7e455b209ed731ac2e145"
    sha256 cellar: :any,                 arm64_sonoma:  "e92907b5bad4bf44a04abf9ac6e4f236ff12c93c00c37a6cf8f4b532eb4b9560"
    sha256 cellar: :any,                 arm64_ventura: "839b9b3a33e0ff28d80c269d397f7a26c4ba5448ceb48c205ca9a29b648c75cd"
    sha256 cellar: :any,                 ventura:       "da2dda58678c8aef0d9a7b3dae1fba8fef8142a3fb8d48283149f56d649b49cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e31944a5f1222c69a5185e9fc5ec3d829d80729f7e6c9e15825ba1081714d5a0"
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