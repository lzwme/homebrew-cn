class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3599.tar.gz"
  sha256 "6058cdbe46365ce5c353336f62c8b0174fd108146e6f8f30118e497899b193ed"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "da70739ad12cbef2668b485b7b3cf15302bee097971adfbe90a0dbe569ce5b05"
    sha256 cellar: :any,                 arm64_monterey: "9267fb510db36d009ce30cfbf10b9171e26d3602fcddc02ce4b4617797748bb4"
    sha256 cellar: :any,                 arm64_big_sur:  "20213006704637e35230385ad8f38fb4a7df7a6163c552c1c02ac10f84922de3"
    sha256 cellar: :any,                 ventura:        "5c7ebb5e8ea71e48ea52492be561af164f9f8a9416fbedefeafddbad28829c6e"
    sha256 cellar: :any,                 monterey:       "844d26a56d3f3758fd3b1f5b53b2752f6ba189ba7498813cd48ed7a7bc7944ca"
    sha256 cellar: :any,                 big_sur:        "78e5a8e2736849d961f0b5fc5003bcd49956912c71721a771a3ac0576e6bb036"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5e934dc7aeeec54a4bc4f97dd38585e1168cb6fec9f679c744615bef645e556"
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