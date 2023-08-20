class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.668.tar.gz"
  sha256 "e0df4dc3b262ce041a770a2fa8624bca84bba753b2b0057c6cb9f08dd178ac36"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1cc694d38ab2f7a9e01dbdfe3b9f834070f5458b96cd885b6fe9b0df14b5111a"
    sha256 cellar: :any,                 arm64_monterey: "3223a52b981a1632d916e38c737291e26aaf62f5dde6ecdd6246c1c5162d6f3d"
    sha256 cellar: :any,                 arm64_big_sur:  "ecda8885a8c781c7217b1f7eaf93dc5400c85760c9a096e2d189ef0f0997a873"
    sha256 cellar: :any,                 ventura:        "166736aff53356634dfa9a069d330cf5bc54cf9bcf1949dcf7624512f52ae5da"
    sha256 cellar: :any,                 monterey:       "8ff6f629acf72ef86e84f3abb42b7b27a759644826d8656c76d97566eb4303b7"
    sha256 cellar: :any,                 big_sur:        "a1db42fb09035014f44c0487da2515cf0ad9219ac2161a5f611172170b6cf87b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb36b0528c8c2c77ab78efb9589252b72dca6dc5defd3a2193a8a8b958f99a6a"
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