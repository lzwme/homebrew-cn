class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1249.tar.gz"
  sha256 "7885e0924648139eccccabaddf6e4e1b1fe68cb75ee94fcb183524e2b94289fb"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bb55df01ea6e7771d3ff169fef1c2f873237116035461832947ae433cc4841ae"
    sha256 cellar: :any,                 arm64_sonoma:  "2dbae7add0122e8fda8a5da9bae56f3c6954f9710bc80eb99c48279fb99f9b91"
    sha256 cellar: :any,                 arm64_ventura: "d21c42ed4001f1d6e33b08ef6a7e44685b480a315ba1529071d6bce28a38790e"
    sha256 cellar: :any,                 ventura:       "3dd14bc2ad2c28bdd8d4d01e1197b895b966cc5dfbbd5c15eb7d9279426dd374"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccb49a2cf7b26e475b45de724b354861ccf88b8a1e2f33acda2337ca85fb7e93"
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