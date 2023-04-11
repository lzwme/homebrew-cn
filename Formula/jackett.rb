class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3861.tar.gz"
  sha256 "488d5f76252c47242a7c41c5c8fa2be41394bc2f467fab80774a642d785c1110"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "deef7677b5c812d5cb1b44d2325486809fed3130beb1ddb0090aa20dff6ab8aa"
    sha256 cellar: :any,                 arm64_monterey: "7919911048d1ab3538f3493c6aed41ecbed6c77f5a4c96097361be3c2e7cedda"
    sha256 cellar: :any,                 arm64_big_sur:  "788fc075ec6c7be002ae887a3b9f31a3e6971dc2f129605565f911e69079ef1b"
    sha256 cellar: :any,                 ventura:        "61e641577952d9f7b4bdd87950eb454d9ca10d9a5bad7f91616f2c42a5477154"
    sha256 cellar: :any,                 monterey:       "c73a3bbcb37667c96c121e7b36ffb06632280623c6b97dd7447cc4764e26aa56"
    sha256 cellar: :any,                 big_sur:        "560492ba304d444aeee072e5a2bd6ad010d080457ed862ca13134ee47b8f872b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47d2d15eb7ad072ea294bb3e61cde2834d6517945c782bb9bf3c219184ad49de"
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
    working_dir libexec
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