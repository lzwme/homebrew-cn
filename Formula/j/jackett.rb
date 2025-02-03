class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1359.tar.gz"
  sha256 "d271c55e1387d16df440ee1a483960a014feed3c5f1f88a6537bce9a0a7fb1ec"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c506ce35af6812dc8559abb7464b9595db189a6d849b50353c455a63090528d6"
    sha256 cellar: :any,                 arm64_sonoma:  "7459a29a89fc34d81696fbdf5a04c37bea2e9966edbfcf70ea9c79b16eb381be"
    sha256 cellar: :any,                 arm64_ventura: "f53c8df6b9dd9511993bd972e499735933a86745476803eb3322809dc1dc0af5"
    sha256 cellar: :any,                 ventura:       "cd09b7e96a45229a3c4ecd4e1491f09db72ac5ad97d275252c7a9194d6113ab3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cab340854beb750b93f2c864a3aaf1c5e10af2a75487a65c247cabf910f3fabd"
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