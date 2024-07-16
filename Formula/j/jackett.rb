class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.332.tar.gz"
  sha256 "4344b3c383d4bd06d0c9bf260dc979363b5e816342c4fea12c8b486a5bd55e7a"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "635e3082fd34c6ce58445d4b3959e56fe300916a4e7563793828d15f85b6fb66"
    sha256 cellar: :any,                 arm64_ventura:  "a3e27f7dfa7d5554ad1973cae5874d26eb591be81d1caee3291492278a162f2d"
    sha256 cellar: :any,                 arm64_monterey: "b5bb209fae835cd73c38fe9a11b9b77c5ff8fbdcd609b5c6cc1c6b3355c741c9"
    sha256 cellar: :any,                 sonoma:         "fe892f4192c03decc660d7216a956e6a8e5b959115e2f594e420c445b461bf1e"
    sha256 cellar: :any,                 ventura:        "5a761f165480a9ad14d0367c1461e700cff3c6d7f63fa8e9283c1fb357689ca5"
    sha256 cellar: :any,                 monterey:       "6ef9ba2ba04dd127a3f323d9c744b65f01ad750f28a10485b6b537da4c70ee27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89cb51dc86c901fcf3cd5ccb07eba6194f14244c9b18dedc6b53dee681aa67d0"
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