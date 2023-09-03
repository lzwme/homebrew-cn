class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.724.tar.gz"
  sha256 "4fb9ac9f0c70ba82d0d2c40add4a6d6588252b4d27007e470cc0c7a1e2859c46"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e242fbe3193557fe3cfb1195a5f5c35815a6f0ac852c3e846484a3a6e4cab24e"
    sha256 cellar: :any,                 arm64_monterey: "fc4e8aa99b6f04ef96e53e064e244d5b8237c9f4fe2895874af58a53c7fab5d5"
    sha256 cellar: :any,                 arm64_big_sur:  "8215fdca48ecf57554866b9972608d988ee70d9ddcc45ce57facc72859a632a1"
    sha256 cellar: :any,                 ventura:        "b6df55cb6b68031e393d4e9885e4abcd35cc6adf5799dede8a32abff20c91ccd"
    sha256 cellar: :any,                 monterey:       "4c8ff4bda4f10c8a8b47f2d106a3f22eee107a252a6a6abd3ab6c4794cbd400d"
    sha256 cellar: :any,                 big_sur:        "e47f5afc930dca776513e84039a9f2fe98811eee400919550f8d2a1888116dc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fa2ace73fefe298c50092bda1aea88951f3a13ff4baba7b595e1989c578612d"
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