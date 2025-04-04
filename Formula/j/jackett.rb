class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1722.tar.gz"
  sha256 "8d9dc73922b90d773bc88ecd310e7d878a31aad0f5cf60458813c1d1a03f323c"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d56de7d960604afbfb35f53b659e2e68d715da093c78ba8e9c77f9cf54a7c727"
    sha256 cellar: :any,                 arm64_sonoma:  "e34878a25a84cbc4cbe2351e5babcf18e2a77ebec7cf6594757922f495ec195d"
    sha256 cellar: :any,                 arm64_ventura: "6c8af83f784c32ebeb592b76e3c2710be8ed6d9e5687fb76b856ece618a04b62"
    sha256 cellar: :any,                 ventura:       "5d468d80162d657168cff9d232bfb24944e4f07ef240bd19c0ee364ae85547d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e79989edca82428066eb0703ba9c0d4586de4a5f163b032509a82e7ab4141091"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da5e18012ee5cafc07b00d5f3808d70a1cb869916bf250244a90e07f49ce104a"
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