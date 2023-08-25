class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.689.tar.gz"
  sha256 "d8187e77593798430a4c6f782ec43e61c51bb00853d1144eb563cc80bace5f12"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "06d1e734345005739fa46dfb7cbec01fe8993f5579a9e56078395b52197ae2bd"
    sha256 cellar: :any,                 arm64_monterey: "fe6c64497ee7d9b2de0f02bed6d15515671710efe35b2117a904cf592365f87a"
    sha256 cellar: :any,                 arm64_big_sur:  "c41ac3200ef3702a30bf52f78d20a7a5764c307099998330858cdfba9604d5d9"
    sha256 cellar: :any,                 ventura:        "de7d1cd6fdcbda9011e1f760e1a626345d989b47497a1cae75c86083b316a4ba"
    sha256 cellar: :any,                 monterey:       "6ce3343ef6f04253ec6820be33f2179d777e6faed317d4c8619a3d9feca293c0"
    sha256 cellar: :any,                 big_sur:        "05f30b00bd5582fa900a3dfbf3bd648301fdce8638ed67973982fbf0d408fac2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7a57fd7d027098db8c3ad2270132ff2f91baafca58277c844b80d3c71adfe3e"
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