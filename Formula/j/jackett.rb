class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.1556.tar.gz"
  sha256 "bb8b413ac4bc027c331abf1a10c77991345995eddd337b409b2d71756e6c804b"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d7605aaa05a740aaf74566af88f80e8f20f3e11fb5e96ccf0dc7574df6e9c3a0"
    sha256 cellar: :any,                 arm64_monterey: "ceac751d5879462ce129826215d744dd8a7092c7d2f45c684eaf41ce3cad43de"
    sha256 cellar: :any,                 ventura:        "a690919a6cd0a9959b36cdbb31fcba8f63f135bc562a89c1e5957f686e55db40"
    sha256 cellar: :any,                 monterey:       "8886cf0187d40bf836b3d3f14d35901c361747ad477f2e827ad72e4c3845bc47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da0c8f08c8a9a3d924248c4369bbbfc7400bbd1638522227f47f8a525389e9f6"
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
      sleep 10
      assert_match "<title>Jackett<title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http:localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end