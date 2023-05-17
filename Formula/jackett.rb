class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.4151.tar.gz"
  sha256 "eeef3a1a092fb0662cad1b7f7d46bc2b069cb89c4317dca2d68ca66c2342384a"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8d9847ac0d2e9d47c3a51496c4fc32df74aae3595dac57e7479d922b71e6b82b"
    sha256 cellar: :any,                 arm64_monterey: "6585b82611b1d3782f2eeb98d378341076ff1bef71c53f02e34fa8470de093e4"
    sha256 cellar: :any,                 arm64_big_sur:  "c1762d1d41d4776c2fc225ca26af3558d4f55a1f7972d3fa3ca1096a575e0c20"
    sha256 cellar: :any,                 ventura:        "ea982bf659c936bf05afc393a0cae0cfb8d2e2b4ec5044b2aeb778e775652e3d"
    sha256 cellar: :any,                 monterey:       "f438001d8b1c6f1b41743b1afaa27c42c9100b63020ca0953db23a893fda2f06"
    sha256 cellar: :any,                 big_sur:        "a31bdc1adba6da44c67dc4d272cb66b472148aed1b0b16b883d64b1fd1396576"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5131035400742b3f3a77c7c308371b6b4cbe9738de316f92f147c2c21e363354"
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