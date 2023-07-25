class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.532.tar.gz"
  sha256 "a08c36a3c9e80e5f1bbbfc027c99760b14414e8dd4d5dd5b3f4be58f5498d1ed"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "358e0cb02ed47f346142a1fd7d2a14ea57c8d5fdccfca8d6020aff7c295bfdc9"
    sha256 cellar: :any,                 arm64_monterey: "a856d215090470dbd9508617c13515e08055e91b01346a49417bbdf246691ce0"
    sha256 cellar: :any,                 arm64_big_sur:  "a0a3fb561bc7540b81919cc7c4cb391fe92e1b2216b953ea4af8eafd3fe731d7"
    sha256 cellar: :any,                 ventura:        "7d8259ef6270d39955dbbdf24eeedb5291d94ae94b5f55209a38b6e79adbae76"
    sha256 cellar: :any,                 monterey:       "2562975a49b2217b47f1ae6c72a4b065226d1514c9d980170819485d79d81ed8"
    sha256 cellar: :any,                 big_sur:        "b8760c0cb6681ad4c4705cf0683729cdc18afe737047d6572351a3b6eb3038a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d899d16aefdcd7d0e86104c07e551a1ddd94dc9f0ad2d8e1f4807853ac0d287f"
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