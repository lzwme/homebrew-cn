class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.1277.tar.gz"
  sha256 "554b032d388273c2cb191a6d6276f7b94cb9a2065dbdd03cf0bf808e7d74afad"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "beef2871ae1ea1afaca8d21eebc04abdd04cabc7e9b5aaf676de4146a50484ba"
    sha256 cellar: :any,                 arm64_monterey: "c8f262e443707a8f51435a548c37207d1dcd810fb11f7954dd1a1b72476b60c6"
    sha256 cellar: :any,                 ventura:        "eb64374b137d510cdafc2bb4b3b01d9860744f12f1ff3325532848c6ad038333"
    sha256 cellar: :any,                 monterey:       "979c4dcd5f39d55fe8995b2edb7f6dbccdb7ad9d564c532edba1eed949ec78b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba488d904bfce0fe610a34f3b3182a3d2093c4032b2a6fafead0b0c9aa26d686"
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