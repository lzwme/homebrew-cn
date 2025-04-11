class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1756.tar.gz"
  sha256 "0118d1d5d87f4c6bd056d45fe4488721302a2503a8bff80f98b57716cb1ad130"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1ca76c52a026d05ba3bcdeb22dfc13c6453a6d82c57fd0c7720ed79c3c800c03"
    sha256 cellar: :any,                 arm64_sonoma:  "b571cd3c6e38ef3836326aa70803b7c7ffafa5f46076926152cacce735cfa8fe"
    sha256 cellar: :any,                 arm64_ventura: "1dbfbaf65014ede12d55d24ac8a99f7620c26135c25faf82c462bea7169a8325"
    sha256 cellar: :any,                 ventura:       "c2d1d85760f10805af28f96b747303c580e8a84c3a1defd780fa081ed32730f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55fe7500192b74e8e3142d2a6d6b4b3c3846b879a6be352be7a9bd8e6ee238f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69accfa799ad95e82659560f447e11275f9c570c283fe9b4202929cca7b4889e"
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