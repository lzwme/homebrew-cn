class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.635.tar.gz"
  sha256 "fc6f20aead6e1759d760bb45b45829396c3472cafffaca6cabde7012d477825d"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "137c278375a675bdf7762a5c5634f6b75be0b09048f5fa205c7420994b8c2770"
    sha256 cellar: :any,                 arm64_monterey: "b1656e7587be38e668ba6b3f8e17af0adf3359d76dbc71ee8e09dc796fa73216"
    sha256 cellar: :any,                 arm64_big_sur:  "ad7e4a7d7e9029949ae4364160735725a193dceffbed909cea2281029e461161"
    sha256 cellar: :any,                 ventura:        "5ad93d8f2e9622387e7e28f14a3117be246d18a90e0ae6d41066338cd7d6e5ef"
    sha256 cellar: :any,                 monterey:       "cf170f288704879461941deaec8b6d4db294a2a9a5c260a3f003fa7a4682a76b"
    sha256 cellar: :any,                 big_sur:        "130c2585c06151df336ce0b0616c01c205367cd6bcd0d7be792bc521207a438d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea7207d51cc8e3c3b7205744d02e557157b2fd21af885292d1b62d83fc50909d"
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