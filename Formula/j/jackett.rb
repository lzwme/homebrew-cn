class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1425.tar.gz"
  sha256 "259228cb55c4a688ee04935184ef321fdd6dab69415eba54bed861f7a3b37fc1"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c54fb99edf26b7ef3e44472346338dbf7bf2a55deba259f622f3a0082f786173"
    sha256 cellar: :any,                 arm64_sonoma:  "8f89cb11242f75936a117588af17b4dff9bf3ec128b5fdf57634bd1c278533de"
    sha256 cellar: :any,                 arm64_ventura: "a1b063eb5958686d8c567ff82bccac85494dc963d235de2b77a560bce592d8f3"
    sha256 cellar: :any,                 ventura:       "10a88dc27a84b75457624a0e2bf70fc4f1ab2a67f8d183061401e8765c6aa52c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3543ef3304e7477075ee0911a1160130afafa73c91c819e0ac9d52906b001a04"
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