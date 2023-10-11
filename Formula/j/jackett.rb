class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.1000.tar.gz"
  sha256 "4c699048baf95d2b9d7f29cf9fec9f8348020141117f63de93b84b36b92e7ab9"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "59f6b0cd5815ee78c0147c8e9b24d680aa0c7f5c626a2f83d49cca47016138f1"
    sha256 cellar: :any,                 arm64_monterey: "b868badceb338408c8489f548e11252c0d1887ba4a19adc73b241b9d3ef85e20"
    sha256 cellar: :any,                 ventura:        "7fc1d496bd920493c588a5ca08df176993ea5ce4acc4dd079201ba751409deb6"
    sha256 cellar: :any,                 monterey:       "eae3360d91bf3a42932c6216ce243b80dfb79735ed6ae08af28a5ee085e97cd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3849da84c968ed8f01509da549036c393823a62f862add3b08168ec4ff678d7"
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