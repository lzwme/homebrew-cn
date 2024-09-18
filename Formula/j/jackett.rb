class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.630.tar.gz"
  sha256 "30bb16624f87583461f47c25e1eec0b0d1598c80d0b83766d08fbfd32f6195be"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "5cf9dd841f66c1829e5a71b6bbef47d93650e2144c62553545cdcf047740e0f3"
    sha256 cellar: :any,                 arm64_ventura: "6e40461329c8e4b0ad5d3f3abba0285d317efbb49099e0c248bf937c938cf4e0"
    sha256 cellar: :any,                 sonoma:        "de5f229fcd133c7c841ceb3caf760f8584c21f41ca9cfb3ead48533ef51bd4d3"
    sha256 cellar: :any,                 ventura:       "faed7bbe397e29b8aa84c672896601745ffa5288d7ae3acdce2399ac7f0736be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc19428b3fcde5e3486f04b1f1d5890daf2a3588c595e02ca02f38dd2fb72115"
  end

  depends_on "dotnet"

  def install
    dotnet = Formula["dotnet"]
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
      exec bin"jackett", "-d", testpath, "-p", port.to_s
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