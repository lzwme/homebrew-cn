class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.696.tar.gz"
  sha256 "56129f50c7dba4c5cc84bc9b3e0bcb7c68712395cb741dad561fe9c0d615ee49"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "07158048792bb3973687385e8b2294bc733c4e92a45a268e319895e413d8c334"
    sha256 cellar: :any,                 arm64_monterey: "bd1282c9e86a3897fba271bc3c9c3e7d72cab73c08d887184741c6a4d75ae0b9"
    sha256 cellar: :any,                 arm64_big_sur:  "758c894c96be24253f3a4d6ae36fb99bc747448a0a63012e15c60083a63f1b9e"
    sha256 cellar: :any,                 ventura:        "2ca4b9e6a1c6007fd99098081e76be49c8f56a59180884c5f5626649473aadc4"
    sha256 cellar: :any,                 monterey:       "d1d8c3ea3b517fc3bb8e7be7151e3f931d006151d5b5293c5babcc842bd86c83"
    sha256 cellar: :any,                 big_sur:        "f55ab2e5da2ee1fa1130adb3a8dd17318e05eccb3189a7c5bff5c088931da19e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee2d03dd5a910331a686193f89671b40b6f2cb1f11b159a4914789c4c6b3323e"
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