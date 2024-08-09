class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.420.tar.gz"
  sha256 "d3f659b369ad6d1957966fa7fb19f1c7c96f31581bf0845a9400087781c48674"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e595a036c2ca9ecceb7c25886eb56d278b9b268b39367d8fae17741d16d4a380"
    sha256 cellar: :any,                 arm64_ventura:  "327394002aa18d9256f933ddcdc180c832b3236a70108e808150cf415fd1ed5b"
    sha256 cellar: :any,                 arm64_monterey: "fd56ab0865f17a972061aebd9072fe425b6aa8d2975020d41eb1a44e6951155f"
    sha256 cellar: :any,                 sonoma:         "70e80dc96a13eb14324bd7c842dd12d7fe7a9bc6efbbee6fbcd120f2d58eef80"
    sha256 cellar: :any,                 ventura:        "ee63b1950f54f74d1f3a5ef1438910662f10704c2093ff2a5cd35c0d14423984"
    sha256 cellar: :any,                 monterey:       "18efbbe792b735bcd359812a391c704091955cb8a01eb2f6cecc9b48c2f9b05e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab82795f80f4bfa0af34e15e461805239f9ce28289fe92fe81c02045a0439787"
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