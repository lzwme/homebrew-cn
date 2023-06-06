class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.132.tar.gz"
  sha256 "59d0184aa3e43915d897289e161ace86d524893495852a10154233d5f74d8577"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "196dec5a32f0a6909274dcd1660ba8706b6d1e8b1ef162eeee134a593505956c"
    sha256 cellar: :any,                 arm64_monterey: "cfb2f488225d131836865fe78b6391b1fcc14a1749ceee46318c53304ab2e6ab"
    sha256 cellar: :any,                 arm64_big_sur:  "87688bf25ce6ff306d3c3db32511d74f27e276138b97997231aae5962bb70740"
    sha256 cellar: :any,                 ventura:        "c6282d8c5b536fb8495c35b0d32f7fbbc399fd2929942b0bf35d83fefc73c971"
    sha256 cellar: :any,                 monterey:       "7232d98b39bc393a241250050130cd4b62e39c92940d39b5a9f6d666c0e8613a"
    sha256 cellar: :any,                 big_sur:        "3e1854eb3b98505ae67f228f5b750400b9e0b10b1aadea1224d0d75f805068d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6656744137d59479ac6f1fff68d48dfa5c9b973363a4aa0e79b972826c2156a"
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