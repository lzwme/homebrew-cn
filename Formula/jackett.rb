class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.4057.tar.gz"
  sha256 "af7040d463aa92995175126bd48583a0766b2493dafa874a15285251bbcd7b0c"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0c7992ded420aa3b32a928d071cd648fbc5191cedd91ee58cc02f95681f9b180"
    sha256 cellar: :any,                 arm64_monterey: "bca2be8d942d38fbee8ce17c59a926a62fc566ccb0f0d4af518f206ae5c87f46"
    sha256 cellar: :any,                 arm64_big_sur:  "7d6263c9ed2fd6fcceb25bca3e90374b3381736c92daf493be26cf8cab014c6a"
    sha256 cellar: :any,                 ventura:        "4117f75a2ea441c63a254171444a871ab2e322e3c152c774f70d4763bde8470a"
    sha256 cellar: :any,                 monterey:       "80fc50b608381e4f803df6f4cfd3faea59057288b969ef2558d1a006961fef58"
    sha256 cellar: :any,                 big_sur:        "e20ede118b4f9dc8e77a5d2b68b47d79b48685a202664730317fdd2efec6395f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e5794e42c39f053b9adc5318854a4bbb220265771e6300558b36a3e09782a38"
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