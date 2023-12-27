class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.1446.tar.gz"
  sha256 "c570b5f99a9afe79340e8617fe85a950060c243c9acd52deaf5264eb8665797d"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "56d01b752a0943833b2571aeffb6db625cc39c4a002382a6ea1eb0b939e8c24f"
    sha256 cellar: :any,                 arm64_monterey: "3d80905610529f2141a044f0c98dafac79b3c30d909bb84fc62b998e6eb2804e"
    sha256 cellar: :any,                 ventura:        "f481d1b358314c6b9eac7cb949ee255fd4e5c6bf8f61f85d87369e7430802bb2"
    sha256 cellar: :any,                 monterey:       "5dc4aff4c2fc69579c59ad6a2c1b35beb7e96eecc1ced98862a97097fc24540c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37f797f2e63be3e74a86c0d91024b263f5f3ec551d5e6bf6b17b93a7a010453f"
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