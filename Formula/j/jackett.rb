class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1669.tar.gz"
  sha256 "071c94134dbc868829fb77022431985459c40b233d67e00e11ec72d5e7e95449"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "301a498b38dddd01f5ec06975ccc151255ad7b0aba5e5ce2e5606f86739e1061"
    sha256 cellar: :any,                 arm64_sonoma:  "68c8a5208632ae2dcf4d7031ba2df33676cb716516aad8cc1428738e0c680fb7"
    sha256 cellar: :any,                 arm64_ventura: "ca527c1a5e3257d92a4b866738fba0bf00676d3f6172778fffaf5b43c1ab01d4"
    sha256 cellar: :any,                 ventura:       "732d1e5be266b5b0b7f396ea5faba7b0f3a4a53ce163271fb059ebd9b0ecf030"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9dfe0f2b68f2d62c25b08359196877a579dace673f4e232b2ce9e57c36d0c36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc2361a75f1a4ed5be7c912d3613c7adcd97bbd20b9c9e06b5a0659d4e7cf300"
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