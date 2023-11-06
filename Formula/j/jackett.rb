class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghproxy.com/https://github.com/Jackett/Jackett/archive/refs/tags/v0.21.1138.tar.gz"
  sha256 "fc66fee75516d5afbaf67a88f7f8236e2400d18ff15aa316ab596a917df54d68"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "10a703dbff232fc77e8cd97b244db5d5608bf2f6f36637925df66407b28e9d53"
    sha256 cellar: :any,                 arm64_monterey: "2e42ee182dc8bac3bf19e5a80ef372928cfc5e8b103d0c1f225319a89824f1b7"
    sha256 cellar: :any,                 ventura:        "cd0453c986d406f30ab6b9fa5ebba8198af0a9219e0b52dfd282d3b5957c8dec"
    sha256 cellar: :any,                 monterey:       "e4dc1f6d5aa38a8e1dca4d77e2a71ac92a9b8fac12e5af43003b9349352f772d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80cadc8066d36a96fea46856f5d48b24c266de551882faa789f0e4f9b3471c1a"
  end

  deprecate! date: "2023-10-24", because: "uses deprecated `dotnet@6`"

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