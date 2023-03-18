class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3617.tar.gz"
  sha256 "396decd1f3e97f24ca5bc5ec1e66c389fb1482fb8406411c99067f537dc3e56a"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "58ef12da6e6fcd8959c5a7596b111c0694f4743358150ab3dbccb15c828f33e0"
    sha256 cellar: :any,                 arm64_monterey: "f73a9f36f4d948464822615d2294ab066d6515e9c37d5b758b6aa565fd4bb6b1"
    sha256 cellar: :any,                 arm64_big_sur:  "3b06aaf387e66fb1f6b09781cfca16749f52cd8aa6842b1412053dcf67fcb87e"
    sha256 cellar: :any,                 ventura:        "d536a46d300302e13c5baa48e8987ce40779afb73ae4ff0a9d9470d4af7e04c2"
    sha256 cellar: :any,                 monterey:       "89a870822404a45b60c84fe4a8be60dd69c308dc2b67da1aeadc25d755ff6b17"
    sha256 cellar: :any,                 big_sur:        "87f47d0ae330e6ccd681bf2822068c2e58a6ffebafdc58bf42d8f16a788a0de5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9dce7433e6fbf02078ff15b31b1b5579de50066b3350d5ff5800da5ed4df028b"
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