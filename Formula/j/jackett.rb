class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1751.tar.gz"
  sha256 "10e5144674bf04efe502cfa5864f437a67ce51e6182252efb0307db476fdd0b4"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "09bd5fa5623804ed472bf036e86f73ce6be5930eb3bf4b4092138bedaaaab3fd"
    sha256 cellar: :any,                 arm64_sonoma:  "46f2ee86000ea7b98a7dcb30ebf178b926ac856ca1eff271896a09bfd15aea86"
    sha256 cellar: :any,                 arm64_ventura: "e1ad7e2435b1b50cba32461d2178afece6f2ab245744843358d77986a67f0168"
    sha256 cellar: :any,                 ventura:       "46ab5006c4699f00fe74fa14cce649cd89a15d5e55775719cd0f48d44dc82f32"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4b6f5acb82516878b116835cde3a982fe8453dea3ce28fdc520630be78e84a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bc8dc908be4f04f6218911b0693234fc6139d595bab375877c1c222df0a1eb4"
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