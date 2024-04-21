class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.2415.tar.gz"
  sha256 "8097558f0214f8f1c03f92c19c9a546fff3cdb5fe9ecca2cc6be7f17b02f2677"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d1c3b8bd7cab31ed4b52500a997f9944f5e56edb5c7dbcf0235220e54ffb926b"
    sha256 cellar: :any,                 arm64_monterey: "9b68d8083140f32feab2bb51aa63f349584f97abd26f62394bc06cad5a69f599"
    sha256 cellar: :any,                 ventura:        "71cd9ba9fa37d2175c17a34f2fb5420006c9d656abc9d382db9c56f46795ec8a"
    sha256 cellar: :any,                 monterey:       "d1cd1939ba6193763aba2bf429f5c9f156de1375b79a74f18f2cf3da55107aa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "873ea1d2cfb6400b381161261df4fef29bf4a9fff87af921ae87ba04adad719e"
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