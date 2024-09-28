class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.681.tar.gz"
  sha256 "57cc0486ecea095861b4ac7d7e2240469e5500da3f566b38fbcc549b5b045ebb"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fd6be2471d73f930de9500d27ee294f5327f829056f4bbdeb0a7de47efd10ee7"
    sha256 cellar: :any,                 arm64_sonoma:  "18373874011998278a70fa200d2ccf64c0a4c3c34f61bc5a7e66bcf7bcc33244"
    sha256 cellar: :any,                 arm64_ventura: "dbe97614a56145b5c7fe1edd2864858eaf81e0b3639838129b27e921515c5cc2"
    sha256 cellar: :any,                 sonoma:        "865062cb977c9acaa8416722f8b92a09846efe37e20060e3a0071ae3f6224f5a"
    sha256 cellar: :any,                 ventura:       "1774822811581bb92c3281afd9bdea22324e178753c9d4b84c2c02591810f876"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a2c3dde53d9d2f4cad19a18a1566de7a19e0a22bd8cc69f022da4d3ca9585af"
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