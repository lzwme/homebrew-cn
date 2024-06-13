class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.106.tar.gz"
  sha256 "eba527f8558fbab0593d8083c9d6bb6099f5b7098ea3afbd22f368168f694254"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f91137aad2fcb0895ccae0b28b279da0c5c03e4da60274a1a5216a8cd4421f1f"
    sha256 cellar: :any,                 arm64_ventura:  "8f3a4711fdcc13c3be5e690bb804af775275858e182db5e9798670a3201e3038"
    sha256 cellar: :any,                 arm64_monterey: "267b8115f3d92c8df23eea63455ccf71f96c457f562b84debdca1737421ab2fd"
    sha256 cellar: :any,                 sonoma:         "5bb86ceafbceb3045925e11df537fcce5352f44cb8aa0b44b9c46176e69212df"
    sha256 cellar: :any,                 ventura:        "534fbac3360cdca657a66a3fd12b18960333b1851fa5011627b861cc663662ea"
    sha256 cellar: :any,                 monterey:       "847caecb9a0a2932ecf8733d204110dae7198370cfb8644ec9900d85ddc48f4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e085d75653efea85a8b485cf6d1d78416b17c536967cb2c58a3478355976c61b"
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