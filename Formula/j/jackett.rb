class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.470.tar.gz"
  sha256 "1eeb9d91590927b4681d3a26a4f2b87233c88be604c146ad50ce9335e3f4c2ee"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "861b8b62063823e8d626a117965a18797f8ea8a6c6cf415cd874eba864b422f4"
    sha256 cellar: :any,                 arm64_ventura:  "51de925ad9b97d563dd70ef28e791a6799c1ba24ffcd5156bbe071b094c33241"
    sha256 cellar: :any,                 arm64_monterey: "7c8171090eb33a7e42a4bc635abcec9c7d76fb277248267d785cba176525871d"
    sha256 cellar: :any,                 sonoma:         "6d8f4fd64abbff3dc935e03056a776ccd8f4cc2dc62d45d3c81226f7b83b033a"
    sha256 cellar: :any,                 ventura:        "a8eec9d70ac71c0f000c53b39af1145e1f85ec1f53ba0f5b813f04032f35c843"
    sha256 cellar: :any,                 monterey:       "fa5efb38f7b1f19acdb4469c9dfa1a8d6b5c3fee660948e56ed3f8caef0cefc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30352aee5591cb3860d93994a27f61a1e22e7454c8e9e99bc27a71a35232517e"
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