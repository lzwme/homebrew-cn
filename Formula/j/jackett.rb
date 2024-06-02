class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.2899.tar.gz"
  sha256 "46afc8ec887cf788655c635cf9d699531619c6ff676525b32ebfba2369e29c8e"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6b9948c55019d6b19e2e84d3101bb92449cef8810d768d621a883f7325b41183"
    sha256 cellar: :any,                 arm64_monterey: "ea5dfe58883d9e1c7fa3fd19e4ab2098bd15e36382d8b9826c0ecf832d538927"
    sha256 cellar: :any,                 ventura:        "50ef6aabde22b83a708778c42a8b715daba3dfec05fdf773fea9830bcae0f751"
    sha256 cellar: :any,                 monterey:       "da8fdfe69605c089953fd8d803962ef42ed96fa814858042443fb54bf7defbf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9b9145f7a2d5c14bb2f68a3b871ef7d791ac69ea97e51af7b5435320a70a3b9"
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