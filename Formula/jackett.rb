class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.574.tar.gz"
  sha256 "341156c70c1ba835d1802ff84bc23ce290d3a535db9e72d122973bb8b382f8a8"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6d163fa5c4bf218dca1a0c5d27fed743e97a2c2d2eea87560266ea49fd80d67e"
    sha256 cellar: :any,                 arm64_monterey: "cfed88408cbd04752d5305f33df12e8e0f16fd4aa13347d0047d9f59f97144e1"
    sha256 cellar: :any,                 arm64_big_sur:  "fb9cf788cb9d9e2fb66a199c0f46666566b6c09efce414fbf2c0e175f791b408"
    sha256 cellar: :any,                 ventura:        "1c078fe159410981675ac9c905a2cb98451a3ffae81b29340dccb34c0a8a9638"
    sha256 cellar: :any,                 monterey:       "eed481cba9d340f645461594f32ebc40b6dc2053ab61c5e9c4ddb5785280b951"
    sha256 cellar: :any,                 big_sur:        "8f3cc9368f71c107169dc83d37fa83e14ba7b85e4199fb06872649aef9ec6dad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "077cc8993bc0365292e343e656a60101b3fe8b1b1a313206c7deb12442886b31"
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