class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.1264.tar.gz"
  sha256 "2975e853c80f513b22c87c2f606062f91fbfc780582f39456dc84d1b47cf9633"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8e36571152463ac1fcd20e9891291a59a168154e52f4ad3151abf81e93c179f7"
    sha256 cellar: :any,                 arm64_monterey: "9e1e3140e11685bf1e998cda968427e523984e5036ccf7b69d222034eac8b695"
    sha256 cellar: :any,                 ventura:        "fed1c9a70eda80be7d226d6cb068ba8b70a3da17cbe2cfe27dc2027563ba610f"
    sha256 cellar: :any,                 monterey:       "f26aa8d488c1c7bcdfc852cc3f33a63968ec8dc43876f9eba7a2c7387982cded"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc6bd2f537479e9908422e5a13b31056119d9043a8e7c04f5f7b569ad4edb794"
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