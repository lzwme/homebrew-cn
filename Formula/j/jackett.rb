class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.2296.tar.gz"
  sha256 "74e2a911e7b3cf3ed8685fba91ee808ca3c68f25a25456633118061c44d815a3"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5781045b7a8670a5b7250cc63e106f7b803194c81baf88e8553e37b7eb7776d1"
    sha256 cellar: :any,                 arm64_monterey: "853e8ddfe98cb6bf4207796f2fee7e46e3fa1d464f322966ee71294e2b6478dd"
    sha256 cellar: :any,                 ventura:        "f2605f9d8030b9f07fc4100d40bbd5f14f3b3d7405511eedbfd7f12e58526a55"
    sha256 cellar: :any,                 monterey:       "645fbc21e2c2dd78f2e7b050d3c34b555b0caf5b46cf8cf5e52f1982f64fe547"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3296805e67e2a7b2ad6e89bb5129ae1bfe596ee06b8c92fb54e52f59df2f05ad"
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
        p:AssemblyVersion=#{version}
        p:FileVersion=#{version}
        p:InformationalVersion=#{version}
        p:Version=#{version}
      ]
    end

    system "dotnet", "publish", "srcJackett.Server", *args

    (bin"jackett").write_env_script libexec"jackett", "--NoUpdates",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  service do
    run opt_bin"jackett"
    keep_alive true
    working_dir opt_libexec
    log_path var"logjackett.log"
    error_log_path var"logjackett.log"
  end

  test do
    assert_match(^Jackett v#{Regexp.escape(version)}$, shell_output("#{bin}jackett --version 2>&1; true"))

    port = free_port

    pid = fork do
      exec "#{bin}jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 10
      assert_match "<title>Jackett<title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http:localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end