class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.275.tar.gz"
  sha256 "ee34a12d2afbd8d8a6c49242465d7ba588ea9bc5e9435fcec29570064603ec28"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3a43913b7c1bbd919f5254cecca08c830ee7cc7db8a52b7513a7eaf3a146177d"
    sha256 cellar: :any,                 arm64_monterey: "f00f4d6abd21f4afd0164f03ed34358fc4e2727f50b00624df283753d44393d3"
    sha256 cellar: :any,                 arm64_big_sur:  "d1e5b2c014f6476aaff93509e8322fa21a447cc66cebfb8f7e53ab4f8b0f333a"
    sha256 cellar: :any,                 ventura:        "7236b57e257168b3308999d425fc0d7fa040b1f9f4037d746d641bf0265603f1"
    sha256 cellar: :any,                 monterey:       "797044f454778117e42e6e76f9edd499234ccd98f343931a99446cb33849b779"
    sha256 cellar: :any,                 big_sur:        "9940f1c60c9b4839b04e7e4ba691b411c87fbfe8f40cab60ccb1efd93ab74754"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "364812350f06fe9c3471eff23e2637e2c20076aeb6e0ce97dace06f12db0ff1a"
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