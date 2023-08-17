class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.653.tar.gz"
  sha256 "4b8a4eae945e7f90b93ecc2d688c8fe87a249d30e4049929af911b46320a5ca2"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7df045a2106b48a878a099c0896b6298bc48cff9516ac2e87a99f900ed0b58a1"
    sha256 cellar: :any,                 arm64_monterey: "e786523e331c0432701c4dbf650fe6a5cf6fb3e3529e61f4e625e35bc17e1df2"
    sha256 cellar: :any,                 arm64_big_sur:  "8db160abe2384169744c8f2e0518d29c1622b4d080f76b5a205072aedf95fbff"
    sha256 cellar: :any,                 ventura:        "dcdd70f3a7fde506d5ae261190f722dd035684a85b56cf70356b55285689ce0a"
    sha256 cellar: :any,                 monterey:       "4a807040e0009a4d8e6beb6f436a9e8228ac2c6f5bc07e9cdab0b71984624811"
    sha256 cellar: :any,                 big_sur:        "9762e911c15b01e16d6754e1910af273e85e771965882af5d4e4818f9ed6596b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca5e710ff4de1fd893de5d7cc8805c58a561948a249ad0ff61d013a65927897b"
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