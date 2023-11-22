class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.1239.tar.gz"
  sha256 "56bff71076a3b81e62c753682e45b02e9cc3f0cecdfacccb88d828d24bb6238e"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4939c3ff409820c71ecf9c22fcfc93a419e10e2811158453c6de0b304c3ac2b8"
    sha256 cellar: :any,                 arm64_monterey: "f61cfec11c8e8380f8f9d1aee81eca640e1e701ad0ea67ad96096e5c1b458b89"
    sha256 cellar: :any,                 ventura:        "dadf6ed2237ecc313917e81364564f92280a55077d55d27459112e4e9c54fdc4"
    sha256 cellar: :any,                 monterey:       "2dfd2570e311811ff0ae76276c11405a598385ff2a601ae6b945fbe32481f710"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ada4a0c1c644ba1ff56f2a9c2842739fb2049fe3b60ad56281ad5dc98f6ee9f"
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
        /p:AssemblyVersion=#{version}
        /p:FileVersion=#{version}
        /p:InformationalVersion=#{version}
        /p:Version=#{version}
      ]
    end

    system "dotnet", "publish", "src/Jackett.Server", *args

    (bin/"jackett").write_env_script libexec/"jackett", "--NoUpdates",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  service do
    run opt_bin/"jackett"
    keep_alive true
    working_dir opt_libexec
    log_path var/"log/jackett.log"
    error_log_path var/"log/jackett.log"
  end

  test do
    assert_match(/^Jackett v#{Regexp.escape(version)}$/, shell_output("#{bin}/jackett --version 2>&1; true"))

    port = free_port

    pid = fork do
      exec "#{bin}/jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 10
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end