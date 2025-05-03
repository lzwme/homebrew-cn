class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1846.tar.gz"
  sha256 "e69543ba25ce03d1d5f07f7100f44c6c81b0e172e29a6648f7b296985338f775"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0008fe353494904b8fdb6bace1095f5b6d57c1148e5dd32d3a06ac32a94355ed"
    sha256 cellar: :any,                 arm64_sonoma:  "cae2d51a791295d8d91f8887808c80c47da34e5cc489e2097afefa93dde2c64e"
    sha256 cellar: :any,                 arm64_ventura: "c471edc5d2d18444ea085f04604f57b191e9f6d4c1a4ea76c9e199b836345ecf"
    sha256 cellar: :any,                 ventura:       "7af26c27670747edbf3ea5da2a4a9d1201b672d8f1e4010819430ac94c4d405c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f11e1ad283c9d2ddcbcffe86f9e9325f5211a9e453d7f6cc5704cb241e3264d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4e7dbb6fe67db31c63b810510e87ef7c711d65a518b2a64e6fb33957a1707e4"
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