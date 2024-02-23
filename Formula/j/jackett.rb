class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.1819.tar.gz"
  sha256 "dca6402f0d78c63caa647c1d536e8606fe7e47706295e6c36c05d95a34388024"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "659848c9cbd9ae0b579343d3c1c17fda392708890b38724442cf93fc05f32123"
    sha256 cellar: :any,                 arm64_monterey: "a5fd49eccbed7e71cc133c4b5664f10721f5eda368f6a108214f8db3ace525ec"
    sha256 cellar: :any,                 ventura:        "ba531a211bed7ec36ce43dada754e3b884b211b455c00ab509d620eddd1a9e0c"
    sha256 cellar: :any,                 monterey:       "41d767222a642add634c098bc35fab335790d3eec6d8057ecbdb9dcca84ca463"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8de348563f27b5fba50dc77bbe08b0154122cf57e49896a7dd3fdc1d4186c45"
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