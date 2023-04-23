class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3968.tar.gz"
  sha256 "5722d4838f2ab1867498b70d001e57dddface6eb88c899f29da67dac14f26b63"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a1b1135c11ba0d76b329cfe8e7bfa2d10da9525be13fa060cdf03da300ceb1df"
    sha256 cellar: :any,                 arm64_monterey: "b44f3b63a71157654736d82a22cbcedf564ce5ee5c5bf8e80e5acf7fb42c2ea3"
    sha256 cellar: :any,                 arm64_big_sur:  "acfb048be2a166ddcc831c04e54d31de34d95c6639be64fc350a037bfb61e355"
    sha256 cellar: :any,                 ventura:        "5fb33dad55de4a51cb036c8f676f1678c180729b2924b9555bcf299446532967"
    sha256 cellar: :any,                 monterey:       "8a099390b406192052fcf92fd4a185898068b7ebd75f3d1d6f3b1790f52080cb"
    sha256 cellar: :any,                 big_sur:        "e365f610c630ecbeba4c923b356037f5d0dfdac7fc41b5f65205b9b9e8fb3c72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09e5671628cf1570fdb6126d68c3d54d6373a66936bc86c3906a7761dc1d9005"
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