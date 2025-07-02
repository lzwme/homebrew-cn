class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.2101.tar.gz"
  sha256 "68b59e58916454b3e3520ee7fcbb623e5070b78d8524c124f3a093bfdd49cbaa"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2098b99e748a8f975148050302a2950b2c00d97dfb120d37e516b63675d2560b"
    sha256 cellar: :any,                 arm64_sonoma:  "fc414b9b370bd3d85f1d0be4e11a041e3f22f680b9307872270484b27a85d180"
    sha256 cellar: :any,                 arm64_ventura: "9e849744c279303eb8831dc37665afd9cfa63ed537f99168d01c35971ac167b6"
    sha256 cellar: :any,                 ventura:       "910757a9ca2aae3b39de97e6621a31d1e3d21bebc1d54703f2f68c3b17880333"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbad2801879dbb5cc5e828d54f81a62fd277fefb99bb06415027afb78f7f471c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7b1f0c6b3bbbbe6cf140a676ef15e126c0300033c012bef78c2ade355921f5e"
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