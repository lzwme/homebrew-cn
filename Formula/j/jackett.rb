class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.834.tar.gz"
  sha256 "0229b2fe6fb1755f4b97eb17b7a8490d812700c3ff14dfc46f2c2979ba561859"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e05850596c176905bae5134e84830354c9c58d5dc7206376af09389ebb687e18"
    sha256 cellar: :any,                 arm64_sonoma:  "d34f5bc8a79a9ea7e70a45dbdd0c06c22b5a0b1d337ae8417dc1e6b017d4e919"
    sha256 cellar: :any,                 arm64_ventura: "452dc5f16029afc1a4343c53751e5a47badeec0b9a5b047791609f5e017b16f4"
    sha256 cellar: :any,                 sonoma:        "84a028f66e6405b5a6c3d2b505b08aeec2fbf995d62820105da81aba0cc4867c"
    sha256 cellar: :any,                 ventura:       "baaf747cd6f912b5d4fe25613156d56753f6c441c9ff138f1dd7ef70b8127a8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "286f3de4b0d8e628271b34da0dfc07923dbf26254afc0b377f0ee3c96828ed7a"
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