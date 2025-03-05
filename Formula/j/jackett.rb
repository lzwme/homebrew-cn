class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1471.tar.gz"
  sha256 "fc1ba61a0265b18e5ff71456d344f05e286a8dd6af8d54b4dac9c1bd9c74060a"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8a3d46d10edc101ed0025ed438497e3938e6e25537bbc45ec8b3f5ca907bb6e6"
    sha256 cellar: :any,                 arm64_sonoma:  "d746302813446e1caa67c7808823153a82826c33880544c5f4849a296dd1a67d"
    sha256 cellar: :any,                 arm64_ventura: "839f59367fcf7987a6dde613c1a4bd7177791ccfdd2582574e28e833e6ccd5a5"
    sha256 cellar: :any,                 ventura:       "34d1c6804971baa60554097826271454980ae32c6a8d9a58506a195a0ce2b07d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7a281de94201184913f4c10bc072284fd4e6343bdf41bbe4ebb8d420dbd494f"
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