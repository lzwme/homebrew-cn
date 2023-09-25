class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.887.tar.gz"
  sha256 "8248f4b47b37084680e9ec3e992a7614c40b1b322be26c20b9fa9316b7ab9f9a"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a113ed223dce61e3e5076d68bd3e64cb2b99c67f61ce54c9ff6b2546af21cb86"
    sha256 cellar: :any,                 arm64_monterey: "91f7cd8924696cc2331369aaa5e5bcb7371d95c54c83137540a6e81f7e3a62b9"
    sha256 cellar: :any,                 arm64_big_sur:  "7250440865c0659084bf2d8b4945b8d5231ccf5025c6c9348128c930cf6e6073"
    sha256 cellar: :any,                 ventura:        "d8a5cc7dd4d8367b63c74f103c7dad758b5e8e35bb8719772e65276ee9e54fcd"
    sha256 cellar: :any,                 monterey:       "6117d81c9c3fd920b8da48aa487e9d08a3fcc5d97db348785b2ae52cda4f4b8e"
    sha256 cellar: :any,                 big_sur:        "451a5b02cbcc3efc93ccc4820f9f4cc4a13f1fdbfabb7ad6bbd7bd69bddf51d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbdbb5f4c9b1b546b9a0c28510de48a8068a6b2b8501b9ee700459aabc22c484"
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