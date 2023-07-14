class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.462.tar.gz"
  sha256 "a0f13370298772f95de0e8aa8ee2c32e5046756cdcb2b5970f0643c973c1e351"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7eabb429b1198d4b3dcf21f26220b65d99ae10c4a2d86284b257e6b3aa9c0cad"
    sha256 cellar: :any,                 arm64_monterey: "46e5a6fc423972b3635a50a94078c0788af66ef76fb4a03185a47fad54d05e22"
    sha256 cellar: :any,                 arm64_big_sur:  "9871478953cfe31764ca3c1c2677ab5be96feab9622f7f24305450193dda8e95"
    sha256 cellar: :any,                 ventura:        "351b7ad241f6d7766b28978071a3332997cbd5ab0ad58f959807bd4936ba92d1"
    sha256 cellar: :any,                 monterey:       "6f5894ef8bb8d338ae5beb1e968458329cda91284c6c813c36ab23418d2d6e97"
    sha256 cellar: :any,                 big_sur:        "71b1d28501eb1f2de0b1bbaf9d09470ebdf154c5e8da5f252e3cf3b677435645"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60631b74f639c7d5d94f98642012c93c50f2b261eba67317df48c2a073c71692"
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