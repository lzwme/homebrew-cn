class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.64.tar.gz"
  sha256 "1772301237a9b654d6288ffbc8aa21bf50cbdc3f5dd00fca8609f393eca266c6"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "aa15c9746c4a452832ce40e70e0d7686059f3374a7a438c74e4ce1a9dd62842e"
    sha256 cellar: :any,                 arm64_monterey: "301bf78a481f0c63b197cb8210d2aef3fa4f7c677ffce2bbcf8f6833d5103f92"
    sha256 cellar: :any,                 arm64_big_sur:  "1031fb7fea057ccce472cd09cb90feb76e9576fc5e90cffddb583125f6e15be5"
    sha256 cellar: :any,                 ventura:        "e1edf62b71c248f08ed06f5ed01450227ce9f491ffa7b2c4af4ec49667a035a7"
    sha256 cellar: :any,                 monterey:       "5961b3d88277c54e7f08f35efb4f311a89a6d973a2efde315fe37776348640b5"
    sha256 cellar: :any,                 big_sur:        "1e9e3757f5d4568cb0583e8ae116955bd451b35ceef8b55fa54b5685c6f8be3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "440ee1942f3f490ac90a5d9c9f14c9aae843590e10e5777c199a932551038e17"
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