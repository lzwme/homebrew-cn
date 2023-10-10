class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.993.tar.gz"
  sha256 "27f7872f3ee47e88754e14b37ec354d0eb48a86aa3242ac8f0a6dab9b3dc1fa5"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "da988e77919f65da42e6eaa1e0feb528feab47dfd855409b21044a5f39177157"
    sha256 cellar: :any,                 arm64_monterey: "b02f786c03eba9bd1c3b18024a8cd915278772b8209503e7c2e2495f6b1ca471"
    sha256 cellar: :any,                 ventura:        "7248e95c7ff53be77aeed2e26b7baf6d1d2a8255fe9e73fe4bc236c7a2f19716"
    sha256 cellar: :any,                 monterey:       "211dc92e57c5fd2d519387cd1f2cac06a3676272d933459af7c00d02f372c605"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aaa8f18d434591f320cfd4c299f114c30c74a935f177e3e08f0c3520ed11640e"
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