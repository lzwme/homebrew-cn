class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.404.tar.gz"
  sha256 "8068e4c5834f444990392c0b9f999e92f23f512799dd42e87085f4ff92168859"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2484357ac99a7637a74ff91d0c33efd54310c626e6f5993d0f3ff0156fa7cfde"
    sha256 cellar: :any,                 arm64_ventura:  "260d58f49bc3580158790acc7b3d20820911852b448a4348cf9599cd2859dca4"
    sha256 cellar: :any,                 arm64_monterey: "f86097beb237a72669d8f4854c7a82cf9020cbcccb8b1455b3ea21699c2c915c"
    sha256 cellar: :any,                 sonoma:         "19ab3b364e499ec2720431d0bfc918bb11719a8b6d664f10ccc544d0512c118b"
    sha256 cellar: :any,                 ventura:        "201e01c3779c2ea1a71ada3396a47666695be3d434041d30a98a3f8e4a0661a7"
    sha256 cellar: :any,                 monterey:       "0dad5e29c835c1fa482701f18403f9054f9294292e1a80163a9f9be3f3a5ef7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25f614708e48e9d60f7bddea8ac65f85c5cf3b89f73850cc39f4fab1753e9bce"
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