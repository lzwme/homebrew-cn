class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.1888.tar.gz"
  sha256 "4172aafd6eadf48e1ff1ffbc81b9c1584bf022037c9c61f57db01325e8b96917"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b6a75719b4f435cdd2e41a642f2dc333a4af67866a2d6624ca4ed9c3cf1e9bbd"
    sha256 cellar: :any,                 arm64_monterey: "5196d6b0a2ac1ac041f90e1c9782c1e29b404a09f7bc5f9be7b8a6656116e4af"
    sha256 cellar: :any,                 ventura:        "70d6f37194f83fa4c1aed79ad7b9d955ec0fc16c9bda483a485a7f05079fbe45"
    sha256 cellar: :any,                 monterey:       "ec188e4bcd997e96cb49b079d86b58d1af20184f7e7c9b100db1d4ffb1a95a94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a259104246422f7bf43da9cfc6305f6cbc8df1ff87396e45e1fdcbf144bc341a"
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