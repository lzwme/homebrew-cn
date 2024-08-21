class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.490.tar.gz"
  sha256 "92cea5c253f48c83c9c4f2be81da67884df083a556f80d0091b4b9dafe2b8b69"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f6da775cccd2510f838f92ad4e545cd0ae1b412fb83dbe9b4135747ca529139d"
    sha256 cellar: :any,                 arm64_ventura:  "f18f0e380350972eb6590a68edbb817775605b117c161dc4e051ebc0edafbc72"
    sha256 cellar: :any,                 arm64_monterey: "4b73340e5bb6362c0bc894d47f6a4e9707f52c59ad0e98f6db7610167cbfc522"
    sha256 cellar: :any,                 sonoma:         "022c04a6c131ee95a033eb805b5fd3c8a40269b48161ad1259f38a28089da7d2"
    sha256 cellar: :any,                 ventura:        "41c60c5a4db034bf4b1a498804499aaa939f7149f9ea30861baebae6bf9093a9"
    sha256 cellar: :any,                 monterey:       "913cbd9342dc0a2f32cdb20bb5b43789edcc8b2a759336a30311f98b0274eadb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e089b1a86e86d3ef7913a2f4a8241068fe45fb7f82ec515735c7458bdc4c6131"
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