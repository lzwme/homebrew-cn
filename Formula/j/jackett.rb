class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.432.tar.gz"
  sha256 "3e5a4239c3b29684cf12baf3f92c669bf76921e09990480acebe3cdbe88b31d7"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d3b23192afa573c02a9d71cccd54abba1d4035461a376a4b6166fc8e8e327d10"
    sha256 cellar: :any,                 arm64_ventura:  "b50f7662dec0d2cc1334e848ba9fcd6917c9cb8d5f7be5dc4603d72897dfed94"
    sha256 cellar: :any,                 arm64_monterey: "f2400496ebbf2b85a1ba2aa812eadbec32d327b70c747442ddc805262102c7de"
    sha256 cellar: :any,                 sonoma:         "13f1e23d4498cdc800f0bdb2aa0ebcb24725a3da9955abd327d94bb3eddbf3f1"
    sha256 cellar: :any,                 ventura:        "f87b615176c9a5e23fc7ba313e4d732fd0db877ae448449e38094ada7b741842"
    sha256 cellar: :any,                 monterey:       "939a68f8012bdcbcd9e517d15b20b06239c4cce65f95967964ca4735fcea904f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e3cccb6ee7f7a372cf614463adb0a73b44445ac0e7d563c2f676b299f35458f"
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