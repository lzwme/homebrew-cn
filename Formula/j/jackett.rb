class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1830.tar.gz"
  sha256 "631ce52b58a6f022db497bf97f63bf34410a7f29f3c7e830ccbd04136e210224"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1bb81c76365e79ae1c891452791994b9a8bb8c0b72afc17cf489e37ea6eaf558"
    sha256 cellar: :any,                 arm64_sonoma:  "2bf5840348459a9a46254f0dd792f3a6df68ca538a7acdffa20f978a93887f0c"
    sha256 cellar: :any,                 arm64_ventura: "8476611806cfb3b444171a38bda69f6e8734e4533fa17417e3e693590b119255"
    sha256 cellar: :any,                 ventura:       "1df2e104f419c231a3ef38e09f0b3465f6877471f4c73f9dece437efb5084277"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "406e4c45f91cadc7c670297671aa7b8c154688bd7b30870aff61ce106e864bf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54031a56cf2fbefd667b6cccb80c6b1ced4ed0e90e7b1191be8271c574884f04"
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