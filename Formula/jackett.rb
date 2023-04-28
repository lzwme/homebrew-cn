class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3997.tar.gz"
  sha256 "dcba247ac615a2f8d671e162225cb9e49a1e8dd7c5f9fdeef1cd0113fae3b2ba"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c48db97979901613a966e8e70b0f1df6b29da8f7c026df99331fcaeabc0cf056"
    sha256 cellar: :any,                 arm64_monterey: "04ab500f0d7aedf7abf41dbd6d4b70b00030201e2a53af92ab8b9dc7668bdd3f"
    sha256 cellar: :any,                 arm64_big_sur:  "956b3c6a51c83c95470d8bdad91e2196a16ff3dcb9b715ee491df18ec40de7a5"
    sha256 cellar: :any,                 ventura:        "2467466d4829bdbd93e2afe8a7a894dce9960367ec0b8dad8fe709a781a04fa9"
    sha256 cellar: :any,                 monterey:       "82f707250b2b2556d1111bca9d9dd98d60cb3fd397b1a069abce1782eed33606"
    sha256 cellar: :any,                 big_sur:        "9f4243b3d68d57cf8c8e0203e531558660562e6da96368a00450d1c621681dff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d26b1b5a4e97d6b8496805be2fd932fce4e90df00862c61f7bf28940d53ccb0c"
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
    working_dir libexec
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