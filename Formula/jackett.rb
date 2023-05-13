class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.4141.tar.gz"
  sha256 "6a081253261d2fbb4021ab0a524943f640aa803d905e2d108b79d15ddeaa7b1f"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6a876ac4123275a73f2d6651bc090bbe55d584aca0ee5279941975a589ae22c5"
    sha256 cellar: :any,                 arm64_monterey: "a84a7c16d51ed1c644d3868ef86282e96b5153ed522f291e956671cd3894bbb4"
    sha256 cellar: :any,                 arm64_big_sur:  "152c494b6b94329e7b4e8afd56911e5c3a4c17dbdcab7bb6b3e4c556c27e4a3f"
    sha256 cellar: :any,                 ventura:        "9e857d1b00b9f56c1dea24c60fec88610409f0c204946ba25c84ac493dd3b604"
    sha256 cellar: :any,                 monterey:       "32b87741011f1a29859cb947f35cd334c99715d868ed3896f657f06a79d80cd3"
    sha256 cellar: :any,                 big_sur:        "60c3ea4944a300d3fe62750ef1bab78ed52aa97789871a1db0a99b39fb5e8628"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "067490265aebe62e9efabf10ef2084d66171dacd2e9e81675eea73c7b91d1498"
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