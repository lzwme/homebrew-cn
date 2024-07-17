class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.336.tar.gz"
  sha256 "59fe335f7892221a3e34e399496f37a02eff3bcb1f33f9f55db86e149145ef77"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d04905426651ed163f42451353633dd6923e2cd00723f7a68bcbc946799e5f86"
    sha256 cellar: :any,                 arm64_ventura:  "eaf69732c8f5b9f447f33334fbe2dd8865071bd5addbcc97c6c30a01367ec106"
    sha256 cellar: :any,                 arm64_monterey: "07a635a643c845345d6dfb48e8b3e11866d8bfb1ed4ef24d87711b86bad451d3"
    sha256 cellar: :any,                 sonoma:         "5cb8af5ac5c14ac5884cc55240e1b478f936ed4e5fd90cf788eea24177b850df"
    sha256 cellar: :any,                 ventura:        "f891b85d908377dd060bde98386423f37cd918b87655a7350334f0a2b34ece21"
    sha256 cellar: :any,                 monterey:       "a0a4e05f6047b412211ec9428c43217810b787b5a51b1990d0896a49ca6046c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54b0c34af3b6547d612076ace90a5898bbfbb1830451e8ffa5e2717d842ce7f4"
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