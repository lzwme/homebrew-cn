class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.4029.tar.gz"
  sha256 "abddec3cc09243b69f25e980e065b5968b162706863422e2567b675070f9ccd0"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6e307c7f65f744be20dbc855b51d3fbaadffd6ddb3e00f816127374ea407ef1f"
    sha256 cellar: :any,                 arm64_monterey: "29f2b76ddb90e12e1fe70e24132137e5aafc07f45cca12cc1cbffb10f059c37d"
    sha256 cellar: :any,                 arm64_big_sur:  "6aec3df710fa57088f43ac94c66d3e6b8b8864f96f2ad54cf14a53a3fe4d6e60"
    sha256 cellar: :any,                 ventura:        "bb7fda84bd167771103b7ca18c763a059723f2c74eccb2bf5e4e2cff7a585001"
    sha256 cellar: :any,                 monterey:       "7e74ebd0f26d09efd33f16f715ec83fc12caa617f12785e27e3b86b5608d9394"
    sha256 cellar: :any,                 big_sur:        "0ee58595a91fbd92e4af6b1beaa0081eb6aa34fd8ae1bdc3fa4fff63bc9d050a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c587ad42fb7ffcd135a34f1f13e17c62941c30f005a67aa85ee8dcdd56dd15f0"
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