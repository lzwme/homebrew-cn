class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1788.tar.gz"
  sha256 "cff7ad9c97bab0433eba28faa1e7e3ce86264e654617546a7f3625f00a33520f"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "615823e724005d67d8bbbd95f3437523d553340256f733708e9d1fde6ed4f24e"
    sha256 cellar: :any,                 arm64_sonoma:  "d455417c7283f40a58754877f712bf4d1396fba821becaac900363ff4a0c715e"
    sha256 cellar: :any,                 arm64_ventura: "ca34e3d8d3504c800a4082515fc179075029c172ebd7fc26f901d5cf54009eef"
    sha256 cellar: :any,                 ventura:       "e3b1dd69d6faf19570a6f7e41b2c4763f70c2ae8b22159bf42256d6975b13c7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cee6d0d5d3c3ef6e4f79709b56e6fe02421596b93d846c2e8e59eb514b27f9f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48be8214e920c16a23af9b1d576a875611042f5fee91b5cebedf4266e87aa3bd"
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