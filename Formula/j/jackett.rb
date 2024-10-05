class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.707.tar.gz"
  sha256 "ca764635b831372332365cd6553508f548fce408b52afde6eec0532ae94d4534"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "163b0f9328d505e988bacfb5d773a5c5a0a34bf1fd955595a4de2459b4c54133"
    sha256 cellar: :any,                 arm64_sonoma:  "f3ebff9d2f89c73bf9a1b583e4315955eaa60a7c892576b68f5ed1f4c1a98c93"
    sha256 cellar: :any,                 arm64_ventura: "981fd8db8b2a493555dcda84ee9296934a932f77aefda02e1f63f6ed12e22b3f"
    sha256 cellar: :any,                 sonoma:        "63081c9e4cd761e26dfd971843f8b998e13cc928b74d268ef8115b4b0be8b414"
    sha256 cellar: :any,                 ventura:       "ef622fe7087d565359e5c8845e644928807779fa5d2e0bd4360590295278f962"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "038d0e9829663b05c3c905f33b192a2a5984afcbf45d05dd2c64b54bad0ef8a4"
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