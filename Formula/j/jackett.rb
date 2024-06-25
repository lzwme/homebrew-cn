class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.201.tar.gz"
  sha256 "328348463b674bdd53af9ac7d170b66e82b19eb3dad3702bbac915ddd070cc87"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "16a61e650fa1eb209936e40430020d66f323223d060282a7d4008b27a1e3f364"
    sha256 cellar: :any,                 arm64_ventura:  "5231f2e681fb5fe5dc08151f8c36e576e2e1d2cdf80f115a6f97357fd6c948f8"
    sha256 cellar: :any,                 arm64_monterey: "b3af780280427a5d075a6476d730e7b4685468bf9622af9f8e9ea324a9733385"
    sha256 cellar: :any,                 sonoma:         "094452710c0a4139e6a24fdab697a38fbe967c2855640d06107204cfef9f911c"
    sha256 cellar: :any,                 ventura:        "3a7180070a41dc145f48036b2b599d316f14be4dc6dbfef4ba48aa0a8dfd6cfb"
    sha256 cellar: :any,                 monterey:       "7af77f428b0e1ae73a362ac19417f29fe93f53bb2d8357ec371584c68fdb26aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1552211d42f44555669421eb12424fcacc74c73e9e0258dbc48a53f930668dea"
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