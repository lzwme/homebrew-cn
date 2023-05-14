class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.4143.tar.gz"
  sha256 "f7d97009c974a8f467ed811045ac73a3bd91d9a1f2d5180a9d576980862b8ae6"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "56e341d21aea02cf9f8e80235121f01a8c448d2af4adbcdb992bc4ae99f0f649"
    sha256 cellar: :any,                 arm64_monterey: "96f805e1e944f7763a6fdb216d9ed3908fd6f27820432a949993836d4f435e9f"
    sha256 cellar: :any,                 arm64_big_sur:  "ed540134d8e7c509108b970dbd29122f0735e7e879b5e461198839e2ad98b92d"
    sha256 cellar: :any,                 ventura:        "2ad525b9769c9ab2b2d2b905b07b36298ef56bd4061b4c7544b1ce18d2b7d0ed"
    sha256 cellar: :any,                 monterey:       "774bbcedf842f8c83d0b5697405a70635eb115338e0c83ba0f9f0db933c514f7"
    sha256 cellar: :any,                 big_sur:        "c4d3baa509e3b45976c6038131f427fd2a28245347af5bf7da80cf154d670f23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60b63f4a28ccb85e80afeb7b3df1d54ee6889dc6088fc796488d79c5750231a3"
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