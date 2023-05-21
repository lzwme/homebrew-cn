class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.4199.tar.gz"
  sha256 "b3d872af35d0d87ffeb335f4aaf8ae05f247b3b9e25f1478915b3732c4039302"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6f29b739560569b9656fe791b0b91b3406bc9f78baf2fcda8b64be7e3bf36d01"
    sha256 cellar: :any,                 arm64_monterey: "acc0a857df872d7635d5c8db32dacd383701f8bc63c37c4317c31f1570fdc8f1"
    sha256 cellar: :any,                 arm64_big_sur:  "e63945ec19e6e41a49094b4b541eb204450c051a89bd9ccae426e14ce9078bd0"
    sha256 cellar: :any,                 ventura:        "2d9fb41c5a2247147a045d6abb62dafff8c1183b280e08858a8ef9bf231a0b77"
    sha256 cellar: :any,                 monterey:       "76ec882a8087547aa0de9b917f44730c1075038988b32a956f7f376f1dae18ab"
    sha256 cellar: :any,                 big_sur:        "9a0880bee3d99085eded2e1dff4cfcd1fbb3cadadeae6c228175899bc98d4a84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e2c42aa7cd968bc6e37adf3fd0255cb80437101c2adc13573ddda5470413907"
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