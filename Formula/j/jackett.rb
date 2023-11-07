class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.1145.tar.gz"
  sha256 "4239b56ecb86736dd674150f07be05f7944c76d7e8bee96dec15272df7313802"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3499c7f3bbff09ba78711d2224f2bc855d5d6217eff3cf40942f24f1a9f7ba5b"
    sha256 cellar: :any,                 arm64_monterey: "616656253253205f1d73adf99f1ca116b9657cfde8d619da4e2f810cde773b18"
    sha256 cellar: :any,                 ventura:        "1e4a89fdf10f764c3b48dd25ac9698d0a9fa38abb52fed9bf0a0459f780c22fe"
    sha256 cellar: :any,                 monterey:       "1bb1086963318dd4651f30dbc404fca6611ec4fbe40ade9a545b4191f6338aed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00b1fe74f52df28938b031a51a52aa1424c96f1b5a5ddd980723766b9ac96e88"
  end

  deprecate! date: "2023-10-24", because: "uses deprecated `dotnet@6`"

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