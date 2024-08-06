class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.410.tar.gz"
  sha256 "2838ef8d5e0d3890a877e2c46f9163e8d35aa9ba5b09fc66d599afad3eb292f8"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e85d5a301af397efd0881e4fb83c0a1941f0c52172d4dec8b3fbf73d6018582f"
    sha256 cellar: :any,                 arm64_ventura:  "4ac78ce694511dd5b3832243769febbd263dbcacbb7cb54054bbad61929f8605"
    sha256 cellar: :any,                 arm64_monterey: "e5e3fd5d082c765b3a1a3424c70c9f7d28a754b15d2e55d6224001ffd80fcb2f"
    sha256 cellar: :any,                 sonoma:         "fe4421013f6aa4b7e9465677f3d2f70303190cafcf99e492868386006c484265"
    sha256 cellar: :any,                 ventura:        "f44435f89130c325d4ed74afdf671d18ca11096813d11c3880a527abca760c95"
    sha256 cellar: :any,                 monterey:       "2c8a4300865b126c817f1b99ca19005cc81636f0fc9f4f16ff7edb7bc3bae1e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43a80301e4acb57c095e35299088941c8e20a6328e79689ced32bc2b6386fc2d"
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