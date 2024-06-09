class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.84.tar.gz"
  sha256 "1a223fb5aa1ae3102cac713895dc381d4621466d024ad4d2142b273449cc6ed2"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "11f3b03bfa48e3b3c28f746465841b5339c49efbcc1cc07ba3dd46bf1aa3258a"
    sha256 cellar: :any,                 arm64_ventura:  "e8217e28c7ec4008c8746b955a11f80814304d8b73e6b0a627d39cd40ea67180"
    sha256 cellar: :any,                 arm64_monterey: "c5bf847d416bb60beda2c0a9e17794c3954ffd37210c4edb52c335e662d527bb"
    sha256 cellar: :any,                 sonoma:         "6620a10414b8d7161285f3716ba011125df03624284c254f3b6af8ceafb65194"
    sha256 cellar: :any,                 ventura:        "aab66a50f1b8255f3c824b6210fb9900982ed716475a5de1927bfeaaab6efead"
    sha256 cellar: :any,                 monterey:       "7c7a237c5f2550b286d0274370f782a73deb11e884c1cb8982feb8a5675636f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfc6e620db03692283c91a306c47d44624541678055fc0bd12d09d26ca01b5aa"
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