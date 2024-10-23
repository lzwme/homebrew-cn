class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.825.tar.gz"
  sha256 "80bc0bad66e12ed6341f44cd75d122cad6c52cf850e156819fe26fbe28ee083a"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9fc5062df78a03ec4ea33cd1e4c839d52cbcdc5c09fcbc46fb00bc93875e7e23"
    sha256 cellar: :any,                 arm64_sonoma:  "d2ddad80681fddd24b142f8e6fc8ca1f0dc877a60e7ec6911465014e26ffc0cc"
    sha256 cellar: :any,                 arm64_ventura: "5e6b0030ea0ce95bcd0a98cc067a93a077079a5f4a8beef64ab1a103ca9c61bd"
    sha256 cellar: :any,                 sonoma:        "f82d745b03d11d6630c36c49e237a7951220fd943c0d4ec7caaf2cabba9e723a"
    sha256 cellar: :any,                 ventura:       "c34b4d1b746da4a44a34cc22e7c91bf632486bb5cb1c5ad6aeeedda936cb6649"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09e2323d8c7c748e6afd206dfd1789cc24253f308ec19c37ed362428f69dc4e7"
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