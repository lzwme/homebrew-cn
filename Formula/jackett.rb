class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.4022.tar.gz"
  sha256 "89c838ab8ccd252ed14978d27b3644a1e2c124d3f1e26fb0b1a82fffa9c32f6d"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2a141acb89bb64d56264000408fa86e4f0f1532edf16586dbf7ec3bd1ad4532b"
    sha256 cellar: :any,                 arm64_monterey: "bfd3f190e6f76769a412e82e0424f8ed50b02211597576d749ede50b5a3ebb8e"
    sha256 cellar: :any,                 arm64_big_sur:  "221ca9312a3330ff4d23a488b05f03aa18b60a47bc025c0ef68773b38b5b63f6"
    sha256 cellar: :any,                 ventura:        "71f9ad9d47b0ca7c5cefc71820322e8f986ac388840f1363857b8c318646da4c"
    sha256 cellar: :any,                 monterey:       "d5c3276c07862b186de47d191141ff3a068218f9570947070e72606c94a54541"
    sha256 cellar: :any,                 big_sur:        "abe4bc6a8a4c4a3630c2831d4cd9ab24630e9c0b3726e37019ef9800af8fbe40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3beae7529b9ccd23c76f3e4a17521285ef74b12ae7e75afe47ad59ac38a12c7"
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