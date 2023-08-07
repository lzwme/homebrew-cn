class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.586.tar.gz"
  sha256 "1f0bc857ed59a6473e43c0513f7b90b619f27a585f4e28d89ce7777f9e6a5a6d"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "504cd05166dab1cf8093462474ef4af77bbd6d55db6581dbb5dd7ea5b7005971"
    sha256 cellar: :any,                 arm64_monterey: "69dfa18947730a3758fee5edae137186d08e0572e6bd882255004b563dcdad2e"
    sha256 cellar: :any,                 arm64_big_sur:  "10e3ab17c21ab9d9f98550f07ea0c225cbc38bc653b0a56e188bffa4a3adb897"
    sha256 cellar: :any,                 ventura:        "bf1da9be69b589e8f8b45640bbd10dad0dcc398b560cfd362cb48aab15557b9a"
    sha256 cellar: :any,                 monterey:       "63c80138231dcbde184d294c1643f79fb2ada6a2cfbd913313321e61b31b8a54"
    sha256 cellar: :any,                 big_sur:        "308e5fe1e2627be013c083e55440d75ec52a6c3820b1548721506c34d4e6e9fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cfb6ee0e9df089c4ae3d78f94a2c89fa8273b5102c6999877584c5fe19c26b6"
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