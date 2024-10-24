class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.832.tar.gz"
  sha256 "6bfc917f624f6ea1676e6d8bce301f26ce4352246dfbdb551e46f56563deeb26"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "39e926d4dccc517c70a2bf63b095c6fe45520bece50325f920e840dde170d030"
    sha256 cellar: :any,                 arm64_sonoma:  "43eea1a383d04945555d4825525e91c0b07d1267e1ecec48c0d80e01b0e9b9dd"
    sha256 cellar: :any,                 arm64_ventura: "4d4c51f3330bb1f83b52f1e167bca3b611c3bd839e33f3dd722d135abc3ef0ab"
    sha256 cellar: :any,                 sonoma:        "7272a06cb5d448055cfeea32595158a15d16cd3cd4c1309030d3307774a2b865"
    sha256 cellar: :any,                 ventura:       "f775c79c98e073d2fba98749831ccff68f8b4ee232e689fda9a4102a30ec404e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7db240640528c906c9df154f5e4efb6e78d611a7f4e5c646836a8754c8a62e2a"
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