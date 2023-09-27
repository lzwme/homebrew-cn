class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.916.tar.gz"
  sha256 "b7f4f51e6fca2e1d4e9aafb4ac78516a6d794da9a4258061fe3182570231fce1"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4ccdb83e564082aabdfd1fe98ad9012052f031c56d2a549731de369ff9bfa95c"
    sha256 cellar: :any,                 arm64_monterey: "b07784a884d585a9db0b9908091fddc2057725538b0bd9a33f73a10eae160686"
    sha256 cellar: :any,                 ventura:        "8ef7988af84c1eb45dc8011f1d9feb376d712477d90f4011be8c8e6fb033e1e4"
    sha256 cellar: :any,                 monterey:       "8686d0c41fd0ad15842585da45f9bc1060b40c193dbf133517f9ebbdb4f17d48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be995b1a7016e1978a67f5fe4af65814ca694acb9cbb65ed47ceb13e1749f73e"
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