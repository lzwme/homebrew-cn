class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.21.2404.tar.gz"
  sha256 "7393ad27a1163fbc695c45863b71a827c78e628c8ba4b23bcbeb6f040b146c35"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "09586c4407c9c3cc783c175a5c074738da1c50e8e210dde6cbb170baa45ebb7e"
    sha256 cellar: :any,                 arm64_monterey: "b35f62f25f6992837edb0accf93939db36b2dca3357f477293197715ee0a2a51"
    sha256 cellar: :any,                 ventura:        "630bcabac655c6462457965f5b4e4e297bf6671997c4ecbb8da3a840fc27f8c7"
    sha256 cellar: :any,                 monterey:       "efce37b0f0958b3bfba7b73376f3e33348dfb43217e717bcb70bfbdb3062985c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d4a4e9beb924b77e568772ec21b44e27efe28ee7b98decf29b3bcb59f59604e"
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