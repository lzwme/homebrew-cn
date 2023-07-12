class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.455.tar.gz"
  sha256 "99aab553bbe3d9246350237a8d4fd1590a8d0d754509a8fdd734840fa41e7b0a"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9cdc3cbf24310ccdfee4cf3a6d35a2c3590f6bdd32645188ab770b02ec3045a2"
    sha256 cellar: :any,                 arm64_monterey: "a4fc2898b98a2d736d186ca8f56271aaf0d5fd4576d0acc5f7c68143dfccf268"
    sha256 cellar: :any,                 arm64_big_sur:  "51fec10a2c885375f54344477dda0e17afcfffa71b51687ef6645709f9029687"
    sha256 cellar: :any,                 ventura:        "40a435c2702b3fde23c2e05b8f014afe725dbf9b1460cbcd082d8aa829604106"
    sha256 cellar: :any,                 monterey:       "3fa243d56204e61f7047e3938c13bd603d0258bdf39c84b93e35df6762397048"
    sha256 cellar: :any,                 big_sur:        "30b7fd3410f755bc6c0710414cd47b57ac3950d20c12129b4417a0e85effa40d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a4d099f58fbd3d93c6f02bb5bcc104170cd44f2720bb5838524179fe112548c"
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