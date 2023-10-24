class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.1076.tar.gz"
  sha256 "98bda235b0f355aa0b99f0dc1b36b5c4cabddfbb78e934aa28d08d5cb6258084"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ce43c721b89182ca9ff16c0b0116412cb914b5ab0628f692638f5f8c1012b473"
    sha256 cellar: :any,                 arm64_monterey: "63d68537a941a2d4c0214fbc9a9e2140652fc5d83cf181c169f45171c558540f"
    sha256 cellar: :any,                 ventura:        "69296b93eade9cadab3d021f23eb7312137e5c4f190538488365c8e05a18c5f3"
    sha256 cellar: :any,                 monterey:       "507199cc98e8a381121b9f8f4adf09bfc688a34c769e525dd36760f3b399441a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d432b600e7e717532aec94aec096ad9d2e1d2c6d99152b3a741f9667b87d1239"
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