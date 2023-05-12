class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.4135.tar.gz"
  sha256 "f760a11c8c12013e1adc0caeb3d3d9e05797a4d2cc4fda74dcdb94dba16da71a"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cfec523bba853923dd8046a62bb7535a88f9e7b44b2be6c14307b57cb957ed1f"
    sha256 cellar: :any,                 arm64_monterey: "75b1876d392d0d276a625dd637afc576434e68d489979f55adb720755f1b3d2d"
    sha256 cellar: :any,                 arm64_big_sur:  "d0210ae56c30208b2fdd27d19284b3ee58423403131ad4d441cfdf697007d358"
    sha256 cellar: :any,                 ventura:        "bafabdb330ec346bed10b539055e29b3186fe720d5298d939bb6480e1be57f78"
    sha256 cellar: :any,                 monterey:       "3dc638cd521cb6507f0a20f4fe345343fb8949855071e0fcef1539ee1ecc79e6"
    sha256 cellar: :any,                 big_sur:        "02f8837639089b6fd0a85fd38587a3f79b7b87683bf65fcd8ac471772175955f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a09651cd0aff2ade92d67bd861f29c7135c786c1083d2eba27646b81ddcd6326"
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