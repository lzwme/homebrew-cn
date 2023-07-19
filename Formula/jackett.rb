class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.486.tar.gz"
  sha256 "010944060ab47494eff135d13596a3c3239c0815226eb6fa107c1de1f2b97f45"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "dd4e0cb7ea77a34eee2c33957afea73ff4d098a3d02d3a659f6a7de897ba56ca"
    sha256 cellar: :any,                 arm64_monterey: "9af973aa883e1c203a0c61baef94038f4ec835b5749c5e0520dca7b316d2c633"
    sha256 cellar: :any,                 arm64_big_sur:  "885ffad8e970dd64a9f2399da643ace812553b56222cad0fe9e2092a0802b022"
    sha256 cellar: :any,                 ventura:        "e6c5a652f22a721fc7d4cd048a283bd8a8e287c6188dab4a38f8fbdee01682f5"
    sha256 cellar: :any,                 monterey:       "0d92cba8724a9a5c9d0c2e9894e01069b31575c853ddd6225b5eba47b857047b"
    sha256 cellar: :any,                 big_sur:        "0fdc97f3a6e85ab93edda4589c7de974b15c8c914aeb40e8ec7cb24fb8f6a705"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6aa015484b83d2e3c55eecc3acc5be6346aa1a0f362e2cd1d64b7851070e2fde"
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