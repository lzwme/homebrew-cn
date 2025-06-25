class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.2052.tar.gz"
  sha256 "2e585e7a459f5b67db9bd7c9c13b20ec103c7db0957538575f0c4bf92d8f2d91"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7fd59cd7efa542a156fb63643584dc9c45dc605acbf94442e84032cef406a095"
    sha256 cellar: :any,                 arm64_sonoma:  "65cf40776c8f12811a0419e45141838a9d5f936a5986eabe325fcab85f50caaa"
    sha256 cellar: :any,                 arm64_ventura: "90250420d8b197782600140e111b5cf8315d7cbb5db611f5c93ad58dffcf89a3"
    sha256 cellar: :any,                 ventura:       "edbfafa5a846ef034ac943a19855419fdfe3d59a7b1da16beaae79fb096e2751"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbc1fd5c11b7cacdecbaeae70688591ece5e8addfc32139a69cbee90c8246ba4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf7b861b0682297b5ea31ca49dafcf0ee2c46d4f326502519ea459fcf67a470f"
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