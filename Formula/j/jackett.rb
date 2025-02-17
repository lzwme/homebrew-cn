class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1433.tar.gz"
  sha256 "31055570ad10236396266cb9c4b24aebd4523205484044d447108c1a52024f15"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "abc56f1288f5090f62cfe7ebecfed640a43611445458c1cae74a382c25c5edad"
    sha256 cellar: :any,                 arm64_sonoma:  "c620227b6983c76c873a5ad27154949ba9b989aa25d0caf1a6a30e15bfb04321"
    sha256 cellar: :any,                 arm64_ventura: "20cde0e53baf1a207cdbc62645bad1234287a4d612832f80e9af4778d3d8f575"
    sha256 cellar: :any,                 ventura:       "9ba7c57fb89ce2012b1a257b8acf652c386a8649cc80abfc04248bc8035b63b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "122b25138f628fb5eb555b22a37199dbb498bb40d015b338bf42d80bd21e85b2"
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