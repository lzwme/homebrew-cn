class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1062.tar.gz"
  sha256 "4b9776e5628a6b399d4bf42f46a001a27170dcc50483fadd26954e8cf5ccccec"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c5168ef2109d9ae4bf960368f996b27d306487dbca87a6df6d4e395d4fc8694a"
    sha256 cellar: :any,                 arm64_sonoma:  "62d0e0a46094ea1407563b1746b18eb2e4058b03d8f7d5f33bbef7081e577c5a"
    sha256 cellar: :any,                 arm64_ventura: "b230dd55712eabfe7bcf555a07a4908fee79ff7e0fc0981c8f1aacd8c4730824"
    sha256 cellar: :any,                 ventura:       "55b44fab61dca9f48bebb0a030115a1491d2b33f0a3a5fb9e0d1600e5e46fe1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22ba2da7e65f54e3c0c3723885c3d3e29afce72900ee536dcea5b781471f71e6"
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