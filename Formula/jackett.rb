class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3756.tar.gz"
  sha256 "b44978f76947f3557ea1265f3a5999aae7414b1699d67542760d3e2544fc927e"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7482112bd512f7e347b59ee016bc7c3f921ab5c7d3a1e0a454982b093a9e82ed"
    sha256 cellar: :any,                 arm64_monterey: "f0491ce6c00bcb22733e1c5b3839ca35b05fbbf41e3ad592e55be081d11bd267"
    sha256 cellar: :any,                 arm64_big_sur:  "6b7692db305040b7f4b51def764479e3bb726d00cffc28bdf12af2cda40f14e4"
    sha256 cellar: :any,                 ventura:        "4df7f8f0b84f692a55a335198f8f60e067d3bb80ca2e4d788499bcaddab7e6d7"
    sha256 cellar: :any,                 monterey:       "fac40b0e320ef2f5f554400c96a0343135cbbe71eba4535e051d726c83b893ef"
    sha256 cellar: :any,                 big_sur:        "4c48e8039d75f2d133077d924ecb32c0678724755794a68164d5079ac1efbdd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45cd07987ca70c6cef21a9eb0b3b37d5bec46c2de1bf20e531214cc127789016"
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