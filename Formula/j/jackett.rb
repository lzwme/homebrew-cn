class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1823.tar.gz"
  sha256 "3e9ce2fba46c0f10ebad34e9d67865c649f64c4002d84356ae0f48951b5006ba"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ce2e340c2eaed226f0af76ee4f025a06fdc55c86a6a9c989aae03dd213134ddf"
    sha256 cellar: :any,                 arm64_sonoma:  "5430dbb134b513000d92b013fe47d4c7bb877e21e0f0482b2e67f7f755b97b10"
    sha256 cellar: :any,                 arm64_ventura: "50d09dc93c0f7687083d2ebe29d8c2630b2e507672b55553ba0350baff5112b4"
    sha256 cellar: :any,                 ventura:       "d4150c54396ce3414b7b8142a8ac4571a9e511d35e247ec43d7442e4d801fae9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34e2bc44c29b78985ba31089f9ae6ede3d7a3f1d559394b2c760c0ff1e9f208d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b120aac0e55b2295362327c384aaadc8e299bfe1b1e0ad4769fe0cec5eb05ed"
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