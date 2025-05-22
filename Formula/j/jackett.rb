class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1933.tar.gz"
  sha256 "0113a2c5761768c3e485a9065a99fca01adfb8ca4e24c66134e389f18c02436f"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ae6b54ce32a88d5c261ba1ad0d6949497d4b47e2b00187aa28424b8478fb220b"
    sha256 cellar: :any,                 arm64_sonoma:  "92055965c351a21b1fe621d645f6f63ee5ab6ca860557b01ca1f690b9f534d0a"
    sha256 cellar: :any,                 arm64_ventura: "b473c130afe0e6dee37dc9e2a8a17e123bcc2d6514e3a53c028ef9852d960f4f"
    sha256 cellar: :any,                 ventura:       "abeca041539a321dd7d0b265fc889fd3ef34cb2bd1bb8a4116eab7dbca1f8e0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4d82e1ab393dd79ab5e940b264e8fdee9505183057ecef0d585da796765ade3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc5cc2ef1eb8c9ae238a90beabd9e6ede309596d024778c077fdc73046a01f36"
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