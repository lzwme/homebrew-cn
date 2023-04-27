class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3996.tar.gz"
  sha256 "bdcd61f86975b4c1ea54265494922815e6f051a8145550698ae1c5268e153c6d"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a71fd46f9dfdaa46d3d9bd1a438273f970cfdefdbdc8ae9c6c7c21420493212a"
    sha256 cellar: :any,                 arm64_monterey: "87472b0e933e3eda0c40a86d44fd10f7513c1566ad74454d6469408b7ecfe90c"
    sha256 cellar: :any,                 arm64_big_sur:  "8e5ec1cbc8da3df9f9ede78bcb87a09e168dfb3acc82cb190dc8456b9b4967b5"
    sha256 cellar: :any,                 ventura:        "e855e1f08d2c374bcad8cba21b9d0fc668d47203fd5cc7c813881cc76d54b927"
    sha256 cellar: :any,                 monterey:       "3004a36580c56866322af3b445d9a80b151f3bf36ce07337ab0648548779637e"
    sha256 cellar: :any,                 big_sur:        "bc71f89ef3cfb2cd52c4d0d70c181c819efafd6372ab3605c94978496b52328e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff4a1bd862315cdf4d3c376917a2a4a382356bc34766cce6b2fd1d5656a266a6"
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