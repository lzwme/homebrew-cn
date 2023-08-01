class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.565.tar.gz"
  sha256 "f6b07d04dd71c128989ae6890826ff3552a9028f1e085a9a69306ead3d3b1a67"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "17150761344e5f07f3f727d6b66066d0d3f2a48362b0f44988149ba7ce96a805"
    sha256 cellar: :any,                 arm64_monterey: "5a682f447493a79cb1468c8def4038d23f372f09d4038f905b15f6bb55aa1d50"
    sha256 cellar: :any,                 arm64_big_sur:  "5049ed350551393fef28e61252a9c9b05d9d788334e81a1a65ebefa65cbea86a"
    sha256 cellar: :any,                 ventura:        "59d707bdb33d19cc5d822a6fe1484d1750c822b71a50372f437ffe97d71f14c2"
    sha256 cellar: :any,                 monterey:       "ef04b784b1ce2a78d3a9c6669e6c6785f236f8d500bf4b89c677199f47e61ca1"
    sha256 cellar: :any,                 big_sur:        "01f4d927cfa4b69f495fca51b2054e34984e7c11330923f471c8d71da722f855"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "894cf7d9ac648198a5dbab3af0b79110cf88308afcdf51d3eb258261fabe9a0a"
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