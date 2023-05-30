class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.83.tar.gz"
  sha256 "adcae0242af1ccb68977839d23e5ed0a8823cfd2da0fd37c0465fb1d14d6f086"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "584839f746520a3bfcb8061488b1eedc31722eb443821d4a195d22769556457e"
    sha256 cellar: :any,                 arm64_monterey: "baf39c849555cc945eed60119cb3e9dd414a0f2cacc12939676ed97af127a37d"
    sha256 cellar: :any,                 arm64_big_sur:  "2d17a923987a97f0e06dbcfe31912b7a2b4a90ef9ed7ae7f6ee1ac988e6290e4"
    sha256 cellar: :any,                 ventura:        "7d4812043f9a9267a85f48abdbe9b90534b8b0e7709bc15ee67786fc4cc03c27"
    sha256 cellar: :any,                 monterey:       "40d4ddd99c56710d010d3407f3ccf7f73427b81ab78a63a6ec48a99ffeeb07c9"
    sha256 cellar: :any,                 big_sur:        "9b6a884b4b81623e17e6fb2609d20f7fb709c71c20d3a63a23b3acbc90cda2ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7585f574be1f36c4d5f674cbec4c14e3e3db5641fbf5e95ab5b7029953a62fc2"
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