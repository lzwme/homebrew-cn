class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.267.tar.gz"
  sha256 "0d04e41d9b72f21b891948a70f04283e613d5140e9aa6a835062e5c853090375"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d09c3f46e61b63352d6d6624aeae6d01e092164e4969fef399def2a0691f8d95"
    sha256 cellar: :any,                 arm64_ventura:  "ef0aa98cdca51efe79703c5a708e7399d11ab9fc68d40b7f478900378dce3fee"
    sha256 cellar: :any,                 arm64_monterey: "7b275b0ff5910a00f35c5495c59d71761c0b2c7be0fde924f716255fb6342553"
    sha256 cellar: :any,                 sonoma:         "b543d5ca37ced3e1103056a0f8764be9bf46e5540e378633f0e1d9178eb3d789"
    sha256 cellar: :any,                 ventura:        "b4e86beccdc14eacbb75cd9be34e1fc665eee6035285789406d8a2e9680f6429"
    sha256 cellar: :any,                 monterey:       "a2f32632496d504a63d61f38f1c5232205820fbc7d6578acd23898c53a53aedd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1549da2040fdd80ba1cd428ee35570bc4a6d0a887ff05444719d1e90da93925"
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