class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1447.tar.gz"
  sha256 "987c8ef0a00277270ce72997a5db74decd4f966207ae92d3f483b26ba4f93d6d"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "024571f472392c1766330392c1274b2fd7e35e34b512969dfe19aaeb661c38bb"
    sha256 cellar: :any,                 arm64_sonoma:  "f4c05875785751372fe206c8dc6f548d614e7e31c0bff445fe0615a7655d73c5"
    sha256 cellar: :any,                 arm64_ventura: "679be7071e1bdcac6abfc6e101983a7507f5a80265958503f3627cb69d5f16a7"
    sha256 cellar: :any,                 ventura:       "a43c681cd9830c24f5e688154befa289104c3a18b958aa1356ad3f32d7423ce5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e92a70bb2f9c274539fdcb4e6c67a5721fc0cf95d4a9bd5133f2bfe5c3723b4"
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