class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1800.tar.gz"
  sha256 "9b9fb3b3ee9900bb29adca66864692210829ecbb6b240ecc7b9b14b6a5472021"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "427a48173e933f250244c433f3d1c0552995b1b8c09a14290c8621f89e4f589b"
    sha256 cellar: :any,                 arm64_sonoma:  "52b811a9a7285b5ce0f00f049ecffbd8f8700713bc1d1f3d248704e4f8394308"
    sha256 cellar: :any,                 arm64_ventura: "b9c1f945f075209c0d32eb6bf9b80b8e5ce4cbec3bfb827d24818fc004c10706"
    sha256 cellar: :any,                 ventura:       "8ee632d565b15d6749ec0bf86be20e44b6cfcf06aa9254a642c2f2d20a546ffb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2332f885263d1b2d29085612553a7421b9f644d829e36b9bd35370e9bfaeacb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b596ed3df94b04f79ddf7fd88301a9d20f4ffcdc4a80871edba637e4caf5eaa"
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