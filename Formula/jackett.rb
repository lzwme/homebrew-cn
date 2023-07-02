class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.356.tar.gz"
  sha256 "d1a94bc13ac157b05ff1ccecc01665d81a349d90d2990033407e194c0b9e90d1"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5e9c29badb5491ec3714b86133aa4f98649c8b304716d0d91873ab64154b8138"
    sha256 cellar: :any,                 arm64_monterey: "1978014cb5859962b505b263ce21686060efc212b44c81609c920af20b049bf8"
    sha256 cellar: :any,                 arm64_big_sur:  "cb562f2954057209495f46c3f7bb020f09dd3f055449f9737c7d78f096bf2d3f"
    sha256 cellar: :any,                 ventura:        "ea2931e009bb64759633250fea82d22d2c4a1816dbf1f533a00bc7a5bde6b967"
    sha256 cellar: :any,                 monterey:       "7246651693cb0446eff0a35b36915ed6bde9d32403c1d2e76c4842c45ae9febb"
    sha256 cellar: :any,                 big_sur:        "bd1e6ccfed706e6929bc631793239d5a175f925884a4889ca05ee4452c82c6da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d39922e28c6b23db74fa4fa64dc16e45f52203c8adad98571cf8beca7e841ac4"
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