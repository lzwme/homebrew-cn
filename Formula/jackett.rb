class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.90.tar.gz"
  sha256 "ede99ac11f9890ef66953dac7ebfff314c7f7768f4be37c643391b4cb3fd8d99"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ae707507b560a120007866861cb979eed432871c2f2f5104e0a6415080de839c"
    sha256 cellar: :any,                 arm64_monterey: "62243aaf812e427215cef8c44a7e35e76c384b3e556396a8ce7e46edf96ef3e7"
    sha256 cellar: :any,                 arm64_big_sur:  "e1f33d8e6c610da0f38269b55b9fb6f60befb5797e61feab367d7be9d348b767"
    sha256 cellar: :any,                 ventura:        "3bd4b4f30f1db21a704ee114f32c473061c4fa40c53026c80a4c441756cde4d2"
    sha256 cellar: :any,                 monterey:       "a08a841964e00d93ce1219b793484c0ea2f4afbd44ca0387ad19b1b8a32e1653"
    sha256 cellar: :any,                 big_sur:        "aaeba02495587341b1fe005a90e1f165f069fe9a5f964a1952a919aeef7354d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d20f7cdcbedc27d8017fdcb1c83b1daab4b08750658a45caa1950dc8f39da62b"
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