class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3739.tar.gz"
  sha256 "8dc885b2d0d9a9a00a6c2e19d558f241fe8a4cd028f5add56d07c81023e601ce"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "30e22d9c22a23b0d67316763e5b81ccd2f323b22de8fa5811f6767cadeae791e"
    sha256 cellar: :any,                 arm64_monterey: "0b064372e40b859adf523b3281a2591f6fe4a4a4e809d494f48cb4dbf0b75ae6"
    sha256 cellar: :any,                 arm64_big_sur:  "ab273be6b9962edd8f9b71bef61d79c910c67fe5c8a6ca12a58299941fef3df3"
    sha256 cellar: :any,                 ventura:        "0b4a407cc41a194e62a4abf452b6f0cfc4372f474548b7e5fc7cd8cbd929f217"
    sha256 cellar: :any,                 monterey:       "19ba36bed84e59af6c0bc2ee99ced2da004477c0e45319928a18e44c5d3cfd49"
    sha256 cellar: :any,                 big_sur:        "cdc97b89f32ff41314db08d76faa80ce307e7d3d69bf870513e7c9fdc7058058"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "780459efc2b756dbed5e0cefb35edd1b173f9c4bea9f880254e735fe7432e13e"
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