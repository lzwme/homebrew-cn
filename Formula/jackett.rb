class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3704.tar.gz"
  sha256 "d8738ce342742a11013200ea5854e359d6bdd9bd1eb0f5bd684fcf5e042cf3fd"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "179b155635819437d0b38a95c0b038966c1355006017d2ce99dcfe9a3fa902ae"
    sha256 cellar: :any,                 arm64_monterey: "0a53d3a5757b09a8668e65276558c510268ea843c8e54be22c4d49bb44655d87"
    sha256 cellar: :any,                 arm64_big_sur:  "35ac77b56818134dad6b63a07275d7478a96bf929268faba27fa48a88acc1610"
    sha256 cellar: :any,                 ventura:        "3fb153869a22444b5b52bcd685424d26d6ea463244ea1978d7ac21544134762a"
    sha256 cellar: :any,                 monterey:       "21a4144effc19b088eaa5677c5795eb5beab36505cff306a1cb78f5ad0634390"
    sha256 cellar: :any,                 big_sur:        "be7272162ba99403e40d67c998efe4fb3b69829539deeac55a4d78063015fd67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdda11bbfa6c48a46e48074a87c1a2c0f1455b7baad69b23fb18f9b666827c81"
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