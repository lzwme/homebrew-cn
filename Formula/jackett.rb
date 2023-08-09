class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.595.tar.gz"
  sha256 "4c5c4b1a79f83c6d74f9541176f1d696527d330ba35c0fd08e9dada7f2c926df"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "60d61f86a964192be0ab8fb35a7da57dcac92062fd02f7e3a9af52afef8b06d8"
    sha256 cellar: :any,                 arm64_monterey: "8ea07fe41a187253866ec4790d81e747cc1585ca7a86fdb905a2998f4db3da6e"
    sha256 cellar: :any,                 arm64_big_sur:  "3938793a686ef59a676a9cdb08b681213f0f2d83cb5c9b233667e36639626c8f"
    sha256 cellar: :any,                 ventura:        "506438c6bef23a0f443e950bc64755215cbbe0e46c09d73214f2bb3c0b002a82"
    sha256 cellar: :any,                 monterey:       "4fa71b70b4885523cf4b31cc8a96be538d6a1ebd234f9040e483c37adfb8296b"
    sha256 cellar: :any,                 big_sur:        "6c671f99bced1cdd62c69ae84d4979aefcf18810c63f1cf6639ae2be1923aceb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe4be8c61216ad844156c0b0b25719fcab58a539e31e41b8551e5e5181d142f7"
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