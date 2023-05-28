class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.52.tar.gz"
  sha256 "a399b1567e41b4325729a5ba0e671a534b83cfda6f997b33112c44e9fc51b978"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2a0475360e20cd65ec20b3882f1ae66266c43778caf1e366e52b5b964d9e6c40"
    sha256 cellar: :any,                 arm64_monterey: "18a698b3cf3b8a66b2d9a38d87b1e1bb2682ed0c1ed3300f0c8be13b2dc28d06"
    sha256 cellar: :any,                 arm64_big_sur:  "ad87b4f1b871e610c64424a6a0704ab33046ea9ee1608c3ec069ee0272ec1f6f"
    sha256 cellar: :any,                 ventura:        "e0bef6514138bfba3de64cd44c9f732ca24e25d39b4bba408a722f0a29f88068"
    sha256 cellar: :any,                 monterey:       "d7221129845a4069e3195776b20c1752f6ccd8c346b46491ce429506a0efc04a"
    sha256 cellar: :any,                 big_sur:        "f95701d8ea777f1f65f958e631bc1890e79af591b728eca21f8aa142aef28da8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe8c1bd4f5b03a90dde916c62c332717777959aca4401521d79156c24953008f"
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