class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.14.tar.gz"
  sha256 "22533a1805ff19e20d15a7774c8fc0e8306db16709d047e4cb9dbd9b7e4e3e0f"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "990d17ae2582c4ebe7336f90ce4cecd17c85da81f4d9cb3434073f4c6e397b38"
    sha256 cellar: :any,                 arm64_monterey: "ddaff4791ac2eda1009244e4f2bee3c264e335825b8d63fdc5fc63eef64a59e9"
    sha256 cellar: :any,                 arm64_big_sur:  "88a3882c1cc413a2c5e114fe37f0e6ead22dd01b33bc5ae63df5b5406d409220"
    sha256 cellar: :any,                 ventura:        "c3c9cfb258f85943e00c002500953368fb7e2198322b1b8a9d127617cf83f7c9"
    sha256 cellar: :any,                 monterey:       "ff2f51fe84f0ba03b126043514ada65e28b00ad72223db45ce11ef0d681072ff"
    sha256 cellar: :any,                 big_sur:        "c49ef76338a84b7fe68d79d4c63dfb621fc2729f045f549dc58391c20c3a86f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7aed4a748e0b2265b3d7763c99e3b7c5b62b755ad83714b78fdbd6c3b413b5a"
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