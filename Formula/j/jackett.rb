class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.563.tar.gz"
  sha256 "eb1fb15966f14c73f3f569fd706e3c26550eb67a58324724bccdf81a3a61b12a"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6ee0d33db836d0b3bde539a1ac6a258c755dd0d808ed72f68125fc647a8b0aff"
    sha256 cellar: :any,                 arm64_ventura:  "4ed431d6e80d1c1656aa18871951bdc51fd699ce70349d8ef96a2c74d93ab9ae"
    sha256 cellar: :any,                 arm64_monterey: "0e6bd15c83f8041b38e09e0a1e305bbdbc8f10ec405fb57be4862bdb607320ef"
    sha256 cellar: :any,                 sonoma:         "839158ba4066053e4641b91638007c3d4a6e8a764b9e38781bed4f24a666a74b"
    sha256 cellar: :any,                 ventura:        "f1a3d60fc3a8b068deb1e86deffe26415bd53b34f2233b7af951b4b3652b6045"
    sha256 cellar: :any,                 monterey:       "1a03850daa0d246ff9bde0da44fe767bf98bfae1ed58e7f7abdd04f70c1a49e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcb50b75e7b2ab3fbf1bab18dd73fa180b6170d1ede67ab579b59c255b3028de"
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