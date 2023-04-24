class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3971.tar.gz"
  sha256 "164b669e71b3f2512c0f0f5d5cf3c229a230bc26cc9fe130a69f9a3ad3faee81"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e0db0676c61e6576b9a25df3b141c781d2b3386c71573e9d1404257d2f1ab7b3"
    sha256 cellar: :any,                 arm64_monterey: "c16f4e94b6fe99301d04f0c40c37b91f69d45211b9fd7c88ca5bb0fcd45d49ab"
    sha256 cellar: :any,                 arm64_big_sur:  "a9c66332631d074ac938d5f0c1e044b9163a6ae7249288b4e6bb86c191841566"
    sha256 cellar: :any,                 ventura:        "82788287749f999a60b5862613d03f722587508fd217d1336c1c8aba94efe684"
    sha256 cellar: :any,                 monterey:       "f1264b0bd95c79c2bfb8493cfed220c96d2d32dd92cb84322bb7335b9bac6a0d"
    sha256 cellar: :any,                 big_sur:        "25437365f0f860e7a38e1fb03d5556f2f3fe12dc9ed8f5fbb07b2dbcf7908769"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e033ff4baf57e60d56137fdb45d63a4f9fdd85d28d9270208751a662d89c776c"
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