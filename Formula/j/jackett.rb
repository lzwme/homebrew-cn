class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.733.tar.gz"
  sha256 "22ffa7990b07791d35de4e1697614d7a2201e62b102e91f66e4311e54c29f616"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "622d1172ca020f9e6915f641e1c73a910df74f40d0abecf6a9b7fb4df2f6a3e4"
    sha256 cellar: :any,                 arm64_monterey: "47102b72645043fa8ec82b4cdd659e91d1af27e5e393db812bf65bceca80d760"
    sha256 cellar: :any,                 arm64_big_sur:  "e2e6bec0fb7324d5e0101ed96db8a45f19bad8fdcf59d4c54ff92fa60adf2f41"
    sha256 cellar: :any,                 ventura:        "ef137db17029b12e3750371c25aa1e80ea7fbf9bafd28efae938b00440877d69"
    sha256 cellar: :any,                 monterey:       "f56f077c9706d13cf6794eac78804702b46ff69c403fb174d9afa3c4e3ac19c7"
    sha256 cellar: :any,                 big_sur:        "d22e5c9411330a8c5a53036ef1829c872a006e676d89c1e556da8ad22fc31e71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1862cbb243f62a82491b4f4789f0861e400f04a530e06e8b1fd305b8a792e9dc"
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