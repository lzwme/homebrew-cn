class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3990.tar.gz"
  sha256 "f2a9ee632a3c37036633cb1fbab376f11cac7b9081f383e2e537017a286cd6ef"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e7281bbc1e6cc9e58ae3292e9afe7a4200daad665000ea9b738999cc21eaa136"
    sha256 cellar: :any,                 arm64_monterey: "0b6abb2143db07d3103a069b4f7642d9db94ac2ef33db2ac215bea017030ca5a"
    sha256 cellar: :any,                 arm64_big_sur:  "97f85c446802b798d81897ac4f2708ad796661504eb6fc40bae1f2fa0e0a7a54"
    sha256 cellar: :any,                 ventura:        "dd546f2dc4bbf3f379b8d65b4a88ce99a15c32251d916d8b4e442bc4c2d9bd6e"
    sha256 cellar: :any,                 monterey:       "28c700f17e8fa8d88a0ae2464fea000934b2ca26a8e8e6e51dd28bbc9136616c"
    sha256 cellar: :any,                 big_sur:        "8701a24b204ebc616d224c1b304c79b16fd3cd7f9c0eab87964e46e62efeacce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4a67ee21295458cddf9acb9c31a2ffb13fb049d626a101ab54a2e28865b4b5e"
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