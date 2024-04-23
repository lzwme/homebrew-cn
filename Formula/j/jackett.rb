class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.2428.tar.gz"
  sha256 "3a89c1a53e6a402d4f2e295c221221af710c8bfa9a8654250a8d0d843b30350f"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "02e30ed233d73aff3f90fd8141695032481cb594da6ddaf38d3e5c1a48dfd286"
    sha256 cellar: :any,                 arm64_monterey: "82d7430f2962f0fff7008e9f5a89430c0b5c7d1eb9f6fcc1d91a1197040c08a5"
    sha256 cellar: :any,                 ventura:        "bb77e4e8c2ad8811d22025c07cf4bc85b99c2b2607d9125325127f22c2c0e50a"
    sha256 cellar: :any,                 monterey:       "f8783202f6c24cf7179488a728bceb9c08cf37c02a228e1a8e8311a86469f9a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "243d3e71ba22ab0a5fdf065fdb6266944b267a49bcf1e751a11145e8407f2b76"
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
      sleep 15
      assert_match "<title>Jackett<title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http:localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end