class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.4185.tar.gz"
  sha256 "189160c32a4f4d196d3aff2beee04082500c7b166b44ca9b7ff78d8a151f1d14"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7f0453559d54164335b5388a44d9e497912551428ebe1407356900e5453dee03"
    sha256 cellar: :any,                 arm64_monterey: "a571f7f1bfcbe459ad0925df30bb07aa7dc8975990f8f84e4ee730c949ef281d"
    sha256 cellar: :any,                 arm64_big_sur:  "b572703b673a747b56cd0ff3ec2aafc0e9f9e0e136a3515092b1f434122e7b2e"
    sha256 cellar: :any,                 ventura:        "6ba6b0656a5b207d38f765d2eaeac3e1baea64ee9ae0655e8e2de24951f6a186"
    sha256 cellar: :any,                 monterey:       "fb27a16b272e17bd3e1f13240c777bfa4abfc495e5f99279968b05cd0fcbe4b0"
    sha256 cellar: :any,                 big_sur:        "f1fb7ed1d250bdd6de211245b560e7e5fd6565d8a1965ee9bc29fa4f806041da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7dfa87fcc7aa2000474057f4b3f451bccf13fdd8d98ffd2271c6ecd7f357e90"
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