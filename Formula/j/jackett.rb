class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.2342.tar.gz"
  sha256 "7a5a2db1b934996bf69568ae1a87bdd807bf62c5998946f6c4c2910698b8136a"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "29929e1aa1a28221b3891be7d6c37cf234f88917e0103d1c780d63c7919c362b"
    sha256 cellar: :any,                 arm64_monterey: "f8b2ec4944aabc28ffb7ef4a74989d67093be91862c61afbf708faba0776f3f4"
    sha256 cellar: :any,                 ventura:        "782a691168f073c0792e063ac3252f6c5a4674c80efbc4713b7292e2bdbfb18c"
    sha256 cellar: :any,                 monterey:       "19ef551bde5ac7b161e503b34a784866bc40b0670945f20e84601cfc456714bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57f27b667e3923cc4b14fe7ee80843d4b2f60735c9af964f787e2a661caee032"
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