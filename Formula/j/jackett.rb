class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1014.tar.gz"
  sha256 "c6ad2fa195eda713a5ad03f27f2b230ce1fae61b2ba86dc9f1b455b1c6eec057"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f3d36595ac568fe411dcd688c670761bd2750315f7839efc9250aa08373312c6"
    sha256 cellar: :any,                 arm64_sonoma:  "71d998e1f2403c478cf4a8830284087255a97bfbe8f93bd4cbe61b2c5ee7789b"
    sha256 cellar: :any,                 arm64_ventura: "fcc8e59a7885dd266e63638bd45ac6a1218a8412211e640892fee64036c2c6e1"
    sha256 cellar: :any,                 ventura:       "d0b5bbb3b8a3d822fa68cd64fddc77bbdd12bf5c4c3a6e5d81a5188ff7068b5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f02239457df2b270c2b0e103a7b93b30e10dc895bb9a87b8c74931ba087fe3b2"
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