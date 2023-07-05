class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.372.tar.gz"
  sha256 "ee04ae8723f02dd4416a6903029196cb027894a297a5987e458af7b4caaedd01"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "aa354998f051c76b269a847ef545e2454151efe93820258f376a210cbbff5508"
    sha256 cellar: :any,                 arm64_monterey: "7cb1e5503a14a3cabe7e38f2f1d74b44064f1019c5a7ea674b69923cd5839def"
    sha256 cellar: :any,                 arm64_big_sur:  "a7cf1ee9cddc77e3461a03063652aaa33da9baf7399634f94b4a5f228534dd3c"
    sha256 cellar: :any,                 ventura:        "76f22f0c0e86938ee074de047d87981112590db58bb5440f3daceb4bac892100"
    sha256 cellar: :any,                 monterey:       "2840c6a621d8e503340ce2e9d56cf9849e4fc7f15fc7713d40cefe68019a0401"
    sha256 cellar: :any,                 big_sur:        "90786a5ab3464f1b7110c36b38795a6faad5f991b3f76ddc7c8844647c88354f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b771b3c00596cf8be8368423bbcf63a88bdec20919b4ac21a94eeb0c4a544b70"
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