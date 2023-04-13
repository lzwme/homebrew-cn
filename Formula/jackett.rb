class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3889.tar.gz"
  sha256 "dde991f0b4b3f75ea32b1fa8aa07060634ced13687cb7afc440c2565b91e3de4"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d03d381441a5e8e45a260f1d95406858fb70ecd10e08f816e9b8b4254fc03e24"
    sha256 cellar: :any,                 arm64_monterey: "e95c7c514a1041df052ced12d8aac5ca10b1a03de60080880ab9254b215540d9"
    sha256 cellar: :any,                 arm64_big_sur:  "6a43903eed22e566109cbaa23747659ecef7b54ca62b11e2f79a374136e3f5f3"
    sha256 cellar: :any,                 ventura:        "958f9395d2fc0d43006604e61affaebdd060dc3f982f9af36152e016f134f7bb"
    sha256 cellar: :any,                 monterey:       "89ece167371f6c0324427a956fad82faad8d12e09934e6c67fb9bb3f42bffa4e"
    sha256 cellar: :any,                 big_sur:        "0ce89f166a8da5b0f42acdd12a9f2dc4f5656725d82bee3a840075b7a4fcd08b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83879cea9ff778f6bdcd337d8d9cab397bb02bdc0d780434ea0746bbce929de6"
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