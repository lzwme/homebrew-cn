class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.2395.tar.gz"
  sha256 "8dfc5b10c5d3cf1e49b121ff326f3a9c42ea6003923306b19bb79ae1b80999a8"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "039fc73c9c69ecf104f45f6b026c60b9b44fd78a298f08919eb199ceaac62857"
    sha256 cellar: :any,                 arm64_monterey: "0cee5c61c62695415930400f91f158415ec4b3bd6965731898dff89465c8c003"
    sha256 cellar: :any,                 ventura:        "937ee3bd1558c198df1c8d374417248a189edd34de401ac2666c83e9258aa7c0"
    sha256 cellar: :any,                 monterey:       "aa89db79222fa5ae02429214bce588dd2c6801afef95c51c273dd0495318f0ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef3d9ecc2fcc9b43a07a23ca1321bda8345e298d335b27fb14b4770c69b188af"
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