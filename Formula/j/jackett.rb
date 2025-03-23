class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1675.tar.gz"
  sha256 "15bde4a3d994bec832072153ccd8ed1e92d46f99b496cfbec17d8803732be9cc"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "96aff38af256d1b3cfabd674a9b4ce4af33975536e5413e9f0be4b99f0aa4b81"
    sha256 cellar: :any,                 arm64_sonoma:  "6248215de3c595d2dea66e3df870e9965d4d755e9ce5bc834f4751525b78e3ce"
    sha256 cellar: :any,                 arm64_ventura: "4da788bd874d49b54067bf6b9723b966c2a832d9dcec2a3f43076c3e49727ad5"
    sha256 cellar: :any,                 ventura:       "f819598237af0bae3f0da52bcfd4ca9f4770669852d9b2bc1ab186f694191306"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "115770cc1d5ec13d6ec2172da726bfd5635dc8cc97bd3189cd347fa105343ed4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2725f4d31e0acfc00f40f1dc1a41e6bdd1e209b6f6917a13816e9c5ea0ef9e88"
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