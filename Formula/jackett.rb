class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.20.3717.tar.gz"
  sha256 "8d59369d3aa3b4fc947af582ab6576753188e81c64b1f1268cd82cf15d091eb8"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "71f29ca0a8e6369d09ad016e876f23856024dab4a8e456a62c262ef8adce1877"
    sha256 cellar: :any,                 arm64_monterey: "0275be098bcb4c39efbe1e0a81de599f307470353fe1441b0fe5c20d58929cc1"
    sha256 cellar: :any,                 arm64_big_sur:  "497a8450acc0e3d9b3345ab9dabefef6f1a9d1d85468671b2e808893d4ea3644"
    sha256 cellar: :any,                 ventura:        "dbede5828cbe1f25c58ca15aaade97e4be0acd902b244bae40ec7ff58155888c"
    sha256 cellar: :any,                 monterey:       "ef68aaa75c14cc064d8bf1aa5a6f97caf738b27b3dba9092fe54d931a62116a3"
    sha256 cellar: :any,                 big_sur:        "e2f1e8fbbf4853e4547eafe7b110de1b36d776efc8f3250f5aa9c53437a5118b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a08b284bb5f66975db9102c023356d4c9e7ff3d4e22442d396091741121e03dd"
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