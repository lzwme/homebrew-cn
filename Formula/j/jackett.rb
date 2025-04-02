class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1714.tar.gz"
  sha256 "d72bb57363b0d86e22ed66f439e2e0f0f708ddef573277cd80e0ca54a884b4c1"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e5a80870f43a84edd648b082cac2dd1426af2406a89acf633efc3ca36425dee6"
    sha256 cellar: :any,                 arm64_sonoma:  "0b3988acd5e3ffac86aca6f08be959f288b2e532e7c55b2a38866aceb08b9eda"
    sha256 cellar: :any,                 arm64_ventura: "1b8b425984b6dd142fb1c6b2841f9416a9ab9bfa9584e6ad6bd1cd0eebeca7f4"
    sha256 cellar: :any,                 ventura:       "e7b730e83aeb0234343ef25de02226276b69b7a9a0274743f99ed77348dbae99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f7c2e0ed399fe140b6ac4ff44a530be18c8a1456648a4c5dc283ed9a0f1a020"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8a9b06ac981e1b461f1b4cdbc1e46ae2b6f698f1fb4b4ecb437e1ff4a9f8f03"
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