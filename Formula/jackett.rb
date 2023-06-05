class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.128.tar.gz"
  sha256 "cf4e14a523e0d6f77dfff88466e2e285e246aafdc383b3eee4490a83beba9ba1"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a8704c72c96f5450ef15597646a948a8bc6d8770fe1bca87ee6024f206defdef"
    sha256 cellar: :any,                 arm64_monterey: "87ba334f9c360ce49b52dbe8fc4d7812443265cbd4671f09b4f886129123f885"
    sha256 cellar: :any,                 arm64_big_sur:  "74771f4e967a789560a7018d0e9431d02095548dc9e0673fb9aa18b26f01fd30"
    sha256 cellar: :any,                 ventura:        "efd9be1e71047242a1c03ac816ea375fa4f7454be65819ae8001edffaeb9b9be"
    sha256 cellar: :any,                 monterey:       "7bf956b4cd2a1b789f2c565b1339c0492b0dd394120962c0b5049fbd31c690e9"
    sha256 cellar: :any,                 big_sur:        "bdb89edfbe44e057b133b61c2a8fb3bace770283010136072dedcf926358e6da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89ad22944c60414d2442bcfd72e3a73a53dbeddb1dc018b46e7dc92c4097b6e6"
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