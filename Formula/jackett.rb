class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.205.tar.gz"
  sha256 "7406bb31837fd0d28225b6ee36c79150b7ee06f9eb1db324b6fbccc58f564593"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6ca497c5840f62f30b16207afc4eb611b73eeb06f2b36b82bd2685fd1fe1a30d"
    sha256 cellar: :any,                 arm64_monterey: "a8c8d26d20e069024f27229772e5266f5b152704c1775f061a753861e7cfb7fb"
    sha256 cellar: :any,                 arm64_big_sur:  "a58b7755c796ac88eff2078741fd4599291f0a506f4adf260c7377439413a028"
    sha256 cellar: :any,                 ventura:        "80cc15f258fd569739ac251682f7050450276cde43bc6211f59c0560da064ca1"
    sha256 cellar: :any,                 monterey:       "46997b8dda9880930eb52ad7e1db5eca30173662e42177fce03f62d949967123"
    sha256 cellar: :any,                 big_sur:        "3458e2b5ee0de6ac8ae3ef6296fbc0a162711d52924e06aa56d96f3bba3aa0b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51d7915a966bca9085d598c01546dbb6a95e2f80e4ab270dcb3ff4647b80e7d2"
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