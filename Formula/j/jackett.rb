class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.586.tar.gz"
  sha256 "99aa0d29ee233a58f61b75ec5c86551456cf4cf164d59ca6d3133d4ea24dab54"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d88828e8293ed2c8eacf138564b2c28d00a617a0d15957b18911dbc02341cd09"
    sha256 cellar: :any,                 arm64_ventura:  "c26b69f4e51c37f226f0c9c1212ecd31853fd2fd9915090470e8807818e2facf"
    sha256 cellar: :any,                 arm64_monterey: "f69d1cd5d222909fce489dda40e5d35d1433e9277de993201d2409070f472b0a"
    sha256 cellar: :any,                 sonoma:         "63bd1063fe84e5913a12e94637ed3f0566aea09b9db8b2fd88978ebb7485e038"
    sha256 cellar: :any,                 ventura:        "e27c9738f8792c0b6b95167820b57601e53efd75265f3c84dbec94d30416601e"
    sha256 cellar: :any,                 monterey:       "66e87a36cf98e0323f962af96660c8777f1f7bec9fbf2b8284e2a26826ce5ee5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70cc99e2d6ecd618956e1ff1f1f44c5a5d63bcd6682dad24a3f4cb3d86319da6"
  end

  depends_on "dotnet"

  def install
    dotnet = Formula["dotnet"]
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