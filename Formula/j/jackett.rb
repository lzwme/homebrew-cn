class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1093.tar.gz"
  sha256 "4b4015d918cc1f0c4bff2e570abdc2ce452c107d2bdd21aac2d75408f0bb3af4"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a8bd54caff1e4cb0f8b64dbdbae8f7a662dabcfcd27614c42fd8467a47dda65b"
    sha256 cellar: :any,                 arm64_sonoma:  "7e4f6d540e680faf700c9e889269a8c4d9ac8adae1e963823d91452266c46f15"
    sha256 cellar: :any,                 arm64_ventura: "2deb5129c081678dee1bced91a50990850df8db816f1dc3afd2372b05f096d08"
    sha256 cellar: :any,                 ventura:       "2b085b30fdc4126c683bfac77ad3be6959f102a579c3817d7411bca170dac186"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d815aad9c9663d21ea0f2e19d7032fb82aaac0ab02b360390a0bf7f68dfe098d"
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