class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.491.tar.gz"
  sha256 "87c38f304ea2ec3030b94a43fc5be94e53f61c00dc0a66532f49cd3dc3189dea"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ec48453e93d17f32a4d7f2b01d693e6cf7c61aa058cb0f09366f9dcc032cd93c"
    sha256 cellar: :any,                 arm64_monterey: "0cbe26a153cf5ea197f43bb4c81b05eee2b5d67b5eaf93d34e464fa57bc352ad"
    sha256 cellar: :any,                 arm64_big_sur:  "0cb9298f9d7d2629c8b5b3ec1c625caeac69fb949dbf9519c24724e3a6b88dcf"
    sha256 cellar: :any,                 ventura:        "b602b6aa29ad1e749135cabd5b9b328725aeea5c2d3196af90486bcfaff31d78"
    sha256 cellar: :any,                 monterey:       "4b1e5bcfff4dd4eb50548aafc2fd673c70c9a8c1af6e7b0fface954555d6580a"
    sha256 cellar: :any,                 big_sur:        "c529b7241349e9e6d300cb514ee194b18f25b3fb739f13fe95d2d36422632e5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd40a15d2919e1b29a8719fd6d30b9ba82ff615831230d09a92248b53ed50120"
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