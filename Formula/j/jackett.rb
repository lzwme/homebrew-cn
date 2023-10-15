class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.1017.tar.gz"
  sha256 "c13f17d4e91aa49396c767d1377673186d8c6a7011558bd54a7349bf699da58e"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7a0d6c95293b3b1abe8da27d41ea718dd469b0ffc4c628e92bfc18dbb407dbe6"
    sha256 cellar: :any,                 arm64_monterey: "87ca018664b68f1c983995249dab7e1e10da5912512104962861ba40f6baa28a"
    sha256 cellar: :any,                 ventura:        "568aa62d5ed39cecd3be3b0928346ae6b2cf0e32b7a78be6f48d3de9eb059a4c"
    sha256 cellar: :any,                 monterey:       "9aa743817b7c57b6e7468688382e0224f38376e2f69eed15ed5b82f013b7b7cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0fde8c8c1a2819df9d351612d49aeb6d93f7142edac930dd4e922e980359d4b"
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