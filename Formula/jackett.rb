class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.4101.tar.gz"
  sha256 "c71532972565fc2f529c3151afb63e1fd6162baa578e23d68d4d760b27a62f16"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6b0725485a69fa707cc5fb2c402aef8aecdc5ab11d855640af8ecd1f0563ac64"
    sha256 cellar: :any,                 arm64_monterey: "c7639ada18dc3f9ca60d722457e3fdcea50ded26fc36994bd24bf9cf40cacaa7"
    sha256 cellar: :any,                 arm64_big_sur:  "4c14c3a715347e7400d2eb01a5dc231ce4dcc5793219b56a08e0081e57764065"
    sha256 cellar: :any,                 ventura:        "19e7c9b3a14c2d2fee2643da6e4a2ee597d219cfd880613f332f78220adc2353"
    sha256 cellar: :any,                 monterey:       "bc4d90c95c2b0bbd71f680316c5ce1a57aea9f99d4abce8710c3dccdfa5a440c"
    sha256 cellar: :any,                 big_sur:        "6dffe6ab119f344333f27da9cc7bff4178570b58bb86cc66014b8ba5aecc397f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0cc5b59c3e053143c59bd0cd5705126ea4e0d0dbaae133d3cd912aa843c9b1e"
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