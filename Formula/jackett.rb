class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3642.tar.gz"
  sha256 "4f5da140d969742f979f4d9dd16bb0ce21d1f475d644e498835e6ab39026f810"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5246719e2cea2014234b404642149a67879b437524e81be10e648b2c3ab249b1"
    sha256 cellar: :any,                 arm64_monterey: "949bc47f35d4d1b654282f8713ceef84f96213e4a3af544958e8c71767ecbf4e"
    sha256 cellar: :any,                 arm64_big_sur:  "378c15d17c4eb7d298937acdabcfed0b7c49e1571c494b4b0d9f26ec18e1a5f9"
    sha256 cellar: :any,                 ventura:        "8a739954a609de4b52f1d1683d069f8eb79f546352220dd44242b62b869546d4"
    sha256 cellar: :any,                 monterey:       "26f2bdd66a6051544f8c04e1330d1461b8fba39bdb1d0773c6bb2b32bddba95e"
    sha256 cellar: :any,                 big_sur:        "9a98f52a4295fb3bb9c6923f88b4bf900f0a05ecce24f81c2c33b65bf1b04fc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6426570bb86b081003c2a3800b9cb5586ba1cdab44cfd5a63ae64d8475428438"
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