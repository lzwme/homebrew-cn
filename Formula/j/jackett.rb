class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1036.tar.gz"
  sha256 "97d37a0a3e073a0d40a19b6f58f4e39a4cb9086fee3d10dcf8b672b1d07d932d"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b969534e5ec812f7e4a5d445cdb8524877c4fd4e85355d0a88dcdc1433a21fad"
    sha256 cellar: :any,                 arm64_sonoma:  "7f1cec36593344e60e8e1cce0a8d3bffc5ac2bab7d6b8b27d8150720a67ee7ee"
    sha256 cellar: :any,                 arm64_ventura: "029029aa1fdf5a60814abea15e55f6e40a8a0ee275309128e59e8b9705683641"
    sha256 cellar: :any,                 ventura:       "cf0c9941ea5747346c103701ffd582440d6ec8ea4189af9f8ade40646fa99dab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cadab186c482dc2f6e87d5e096140c06ce3069f7669383ebd54607335f1dbd28"
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