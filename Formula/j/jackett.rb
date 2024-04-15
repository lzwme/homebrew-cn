class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.2371.tar.gz"
  sha256 "5a619ad89e8763fda6a78ea53962fecc56feca8d2a6a0cd4f750d1146fd3d9d2"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a8eb9c941e93870cf375521d32345caa220db5c1dd94216053945bc46097fbf5"
    sha256 cellar: :any,                 arm64_monterey: "eb9c6a67228cc1ece84c752f4302b58b27cdb03d960d25bc923165312dc7d45b"
    sha256 cellar: :any,                 ventura:        "5b1463abdb89fc944313d7b90dc60f3fb91dd3c4d0926e226d9b36556807a871"
    sha256 cellar: :any,                 monterey:       "217ff4ea0a5d9159f228aabd4e1e24e51f9d45f8c5931395d6574d14969ab715"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37ba93d090366a42258245f4ee5fab672e6462472761047f041cae808bad5711"
  end

  depends_on "dotnet@6"

  def install
    dotnet = Formula["dotnet@6"]
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --runtime #{os}-#{arch}
      --no-self-contained
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
      exec "#{bin}jackett", "-d", testpath, "-p", port.to_s
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