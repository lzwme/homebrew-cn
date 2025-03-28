class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1699.tar.gz"
  sha256 "3915fd79d69fbb9259f72693f8809e6920620ff43e40b99b1b12d1da65d7f5c6"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2b7d645204ed827f854c2e7bc931e15376a4f1fc2a3b2d9765be9680f8f52e11"
    sha256 cellar: :any,                 arm64_sonoma:  "22f9bc9f5fdb906f894f671233e38d356eadf67a4a7e7e70bdbae265cb998836"
    sha256 cellar: :any,                 arm64_ventura: "c76e68549d72ebc58f1dcfe7a4477cc1d558515281539bcdad33929e9b574293"
    sha256 cellar: :any,                 ventura:       "6338524247d10ded74e97365fa7eef9e7201e420f8e939fc882dd1251795067b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec7d6ccffb5e23b55fe7cc3b6ba21ad1040e4559a696fe3ed777064d6c14c9a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7d0edae78595a64ec06948eece70817e13b2aba5e6335534b00c63c87a13fa4"
  end

  depends_on "dotnet@8"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    dotnet = Formula["dotnet@8"]

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
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