class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.718.tar.gz"
  sha256 "d773a08446d34fe1885503b0cdf4e8792d41dd2eab01672f2bec37ca0fbb7daf"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b03a59013ea6c3444920d39f6f3adbace01d0beb8f83b5a6f11a906ba10d0690"
    sha256 cellar: :any,                 arm64_monterey: "17684af50f081a2fd81b03eff32f4b8de878f267b7d801ef06d3971b9a314087"
    sha256 cellar: :any,                 arm64_big_sur:  "71a797cd448bcf7fd1658189fbef4890b550c22bab76644d9069750a43bbe464"
    sha256 cellar: :any,                 ventura:        "7fd65bfa85eb13798b20e8fa674426bacff82c30b15a4e39839dfe8f4ee13863"
    sha256 cellar: :any,                 monterey:       "7b6fbe0c3069d75517b5b1209c259fa65f2801da30189e12c81a3b18b1a5d7cb"
    sha256 cellar: :any,                 big_sur:        "514ad102e29dc6712111c6670c6660f991b10457846052876bd7d28c0a2c4231"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76099ac87881071c3381e930edc79d6db7b66c3f4bb545e911f06e00e4d2c00e"
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