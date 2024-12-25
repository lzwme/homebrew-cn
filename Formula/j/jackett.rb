class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1116.tar.gz"
  sha256 "6dfc1f773e9378f38054a538186b389b94791c75aca76e370aa1cdda9c7f53b9"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "50942eb9d82d5970ca0ed1994950254f4e84752b171c6ab44fbef9fc51aef49e"
    sha256 cellar: :any,                 arm64_sonoma:  "00ed646ca4e161776543816a3d3d5b9ba2437fead9a8959b0d4af7f0ca2804d3"
    sha256 cellar: :any,                 arm64_ventura: "3a8ae531433d6d28b3c07de82f6fe8abe90b50bbe79a2c8503fab5d9f8736304"
    sha256 cellar: :any,                 ventura:       "d357b9f1aba49c6f669ed8915fdaab4653e7582a56dd80d82d8a79e3a13a2dda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bdaa3e66053d369cf56faca5bd30d307c68bf0a9f770295a8113d369558f04f"
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