class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.866.tar.gz"
  sha256 "5666e91b396dd870e09f2123e357a7af764cccca7f97ab5e072eef907b546839"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5f898f75395cbd8d948293a80ac128b4f8d5ef9f3a5b87ea27f95fbd8bad0cfd"
    sha256 cellar: :any,                 arm64_monterey: "2ecb3dc231cd3ec603dc54c47272b9a468ce85dbac2213982975f486f994fbd3"
    sha256 cellar: :any,                 arm64_big_sur:  "c4503a9922db770553c1d0bbf5b9c471e4e784c83dd031c890ec2fb3aa8ea617"
    sha256 cellar: :any,                 ventura:        "f81a0dc30cb42c9d865d3cd10aaf057f501ce6906cd036fd7f9f6564c597e95b"
    sha256 cellar: :any,                 monterey:       "1390b557ced4c55a73581cc74101c74ebf0cbca56ee62f9ae7c7836824c9302c"
    sha256 cellar: :any,                 big_sur:        "3f65d5131da8a71619fbd56b51193e4a31b37f97c5678bfe17855db3bf87a0ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4dcc2c179f6c8913b5b2fb2dace6d893a1d3d6300efa31e0dc64ad270ac43e4"
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