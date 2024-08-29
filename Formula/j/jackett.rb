class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.529.tar.gz"
  sha256 "071afe67b632cdbd4c5fc08187434f49d2b444bd6229cc5cc198a18191af6929"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4fa28a8cabf51a8a70418b01ca49676ac48ee85bd4a5572e98c194b2097bab1a"
    sha256 cellar: :any,                 arm64_ventura:  "d0dc7cad641d89d6b9f1104d2df29109c0e10c053fb146a941bd225c724375d9"
    sha256 cellar: :any,                 arm64_monterey: "24efb1f75880b48f8110247e5486238988b0c2f92cbdbb8d536ca99bdf8469d4"
    sha256 cellar: :any,                 sonoma:         "abd68d0dcacbaecb9f6508af33c9f865ee382d8746bca4154a1833084955b2e7"
    sha256 cellar: :any,                 ventura:        "5a2af6cd9989eeb6abfaf49ff15dbee8465d114eb02e5a866f4a7bca4f62975b"
    sha256 cellar: :any,                 monterey:       "05251afae91648180801b13b77c22a6354f7dacfc765455630010809cee33f9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "673fa47dad24e5d65f69b83c3e880c6e59c87d152ac138faa0fafc40fa6b61dc"
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