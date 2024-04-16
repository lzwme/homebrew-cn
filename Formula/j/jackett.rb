class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.2387.tar.gz"
  sha256 "5f02ac9ae5905d7ec3f2a915a7522507dd01d62f9cc35f5950be38da447f7cad"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1ca82500acfe7e41b155748455d6bb7df77a28b89f53b6c3438dc0860e4d4dc3"
    sha256 cellar: :any,                 arm64_monterey: "635eca7a9200e2782d6a1d24ed208931e1034882093a56d0b419264a43d40d9d"
    sha256 cellar: :any,                 ventura:        "d51b6cdc2d5407475fef054c24982d487d72e906f8fb99726e08bf6acea85666"
    sha256 cellar: :any,                 monterey:       "ff944caa1acaa09c16e848cab82bb3445d53ee39eb1af45256ef569a8d516dab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "116e48484fdf1a4055d87657af6656b7582f84c9f45a83d7acf243c8bc973000"
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