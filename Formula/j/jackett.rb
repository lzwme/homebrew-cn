class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.985.tar.gz"
  sha256 "c8ae7059885aefe656de678d27b18d3f9d044e4895ae65d742f85abafd44e7f0"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7b6a472f254b86cb4cbe9bf0947aaa8600541d0b915231d29fbe9fc01e61e7ef"
    sha256 cellar: :any,                 arm64_sonoma:  "f039ff36af312c964fbae3d99afe2a8456733d7f53aec80d36cd6ae136ecd237"
    sha256 cellar: :any,                 arm64_ventura: "9bcfebcd96e3ace0a6858120079b481674e34c71529e7cbd03d09e9d24ec430d"
    sha256 cellar: :any,                 ventura:       "f9d2f04bfc812ad7dbe5eca0a4d049f21aaf584c76d99f3e7558cc1128170405"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c74a60167bae6a8d39f0c9b8a57fbca9e371884c32ef9280771e8a6076bf99e"
  end

  depends_on "dotnet@8"

  def install
    dotnet = Formula["dotnet@8"]
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