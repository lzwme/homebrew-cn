class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.382.tar.gz"
  sha256 "255a2050bf2ddd0b024c2a5ad725604f590f917cb92c9f3e1cae1fbb89505c7b"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4e7bb3e3a26be5036988ef4ba73f2c61a2ca0f0acd1fe18e1af6c96fe998254e"
    sha256 cellar: :any,                 arm64_ventura:  "80d65f65f8e2a3d95e5edc942aef3a27719e6ed55a28d7b742b63d736eb55268"
    sha256 cellar: :any,                 arm64_monterey: "0d6d7691ae53d7d1fb7f7875426956a814e5ea6b812babe912024e411d5192c5"
    sha256 cellar: :any,                 sonoma:         "ae1c2eea639fed61024c86ef2b0918f79f47a8fbab4e443253ac0c4d5785ac3b"
    sha256 cellar: :any,                 ventura:        "4868e96891dc408a3f7532f078905b3a0e0e24a85d7de606fef3c63545fca5a8"
    sha256 cellar: :any,                 monterey:       "1f8a7a339c8fa38326dfb47d7c0e9cb1b07240436451596f824e5f5e9083253c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a7159d57afae1ee593ada1a4fcdc179add6da33cbfacf7db5149d6bbfbe9bb4"
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