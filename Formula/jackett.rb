class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.97.tar.gz"
  sha256 "59c60443073061f8ee7050578f9953c8061d20a17f5a4a6e3904fd4706b98ce0"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "640a65c6639c988a71cca72885686c5dd73ce1f195d09afe4367a0d428d1f77a"
    sha256 cellar: :any,                 arm64_monterey: "126b9a743a56fff95aa94d856f54e93b30ca449437a8322ad0fb0c3c5dd2500c"
    sha256 cellar: :any,                 arm64_big_sur:  "de619c4ba32f24b9fe6da085dca90192cd9da014fe550eede84cff2145fa7121"
    sha256 cellar: :any,                 ventura:        "f8b5b59122e74e1b52842a5f5adf77f3c0f533491d2c21cbdf1fee2f810f8022"
    sha256 cellar: :any,                 monterey:       "ae31a7cfecb5446963e407826dc23ec44683184627ec4a014c1b7d193b27f833"
    sha256 cellar: :any,                 big_sur:        "3e650d28968fd909dce53ae7020c28df3737a46cb656a34041fd7ca4e733ef66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65fcca41212b644300d3a47dfd33ab1a3e784d080b244b85012271b352dfac20"
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