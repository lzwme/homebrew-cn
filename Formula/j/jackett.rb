class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.306.tar.gz"
  sha256 "679b798309c26f167c1b74acbdc8c733e702eb9d38252f042f7a20a5873a6cbd"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cb6998dc7ca24b365ed38392a585c61df16633a99717f47f2d7bcbf6613e6347"
    sha256 cellar: :any,                 arm64_ventura:  "e5c81d9dadacd9b43320c77ba012b0b4f800d3fb27eb857f98cbaf99d83330a6"
    sha256 cellar: :any,                 arm64_monterey: "e2055cdcc1f56a53bc616314376f3bf5f8e7812c15fe18634208934e01d364e0"
    sha256 cellar: :any,                 sonoma:         "4a70511607d8cd1f96afd0e5920b098cdefe72f676418b449b724ee9713575c0"
    sha256 cellar: :any,                 ventura:        "df656af6e54a4f2315824825894c768c547d9673574b65ec5aba15c43be0b7b5"
    sha256 cellar: :any,                 monterey:       "839858dfaaee5d3bc691c024359a0b7a636868929f033600623c0ca6e23e6798"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "761b035ee81cba85fdc37915859f0231207ff93cb004735ab0f409ae86b25db1"
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