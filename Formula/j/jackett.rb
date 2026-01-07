class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.739.tar.gz"
  sha256 "3196f26f397b788fb610cb50a16c2f3b959ab9f35f7a55b0959b79c5ca7e3a41"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "63bb3e3ea7770ed65006ab3162cc38a259fda110e2fbb8f15abddc8a81fed32e"
    sha256 cellar: :any,                 arm64_sequoia: "c48ae95dad88d4d459af96f03451a8772aab580d380acc5b0db0582414b1c7e0"
    sha256 cellar: :any,                 arm64_sonoma:  "0295b67db4b499035e5c6aeaadac5ec156edc16b1ea106699e8614836d2c9220"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43d386d4318c4a0786e03657405480b438bd0cdd1ab053077efb84740c3544b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04c53567ab595cd98584cc329dd7c15b0805947f40df53621f458bd55a65c73c"
  end

  depends_on "dotnet@9"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    dotnet = Formula["dotnet@9"]

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --no-self-contained
      --use-current-runtime
    ]
    if build.stable?
      args += %W[
        /p:AssemblyVersion=#{version}
        /p:FileVersion=#{version}
        /p:InformationalVersion=#{version}
        /p:Version=#{version}
      ]
    end

    system "dotnet", "publish", "src/Jackett.Server", *args

    (bin/"jackett").write_env_script libexec/"jackett", "--NoUpdates",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  service do
    run opt_bin/"jackett"
    keep_alive true
    working_dir opt_libexec
    log_path var/"log/jackett.log"
    error_log_path var/"log/jackett.log"
  end

  test do
    assert_match(/^Jackett v#{Regexp.escape(version)}$/, shell_output("#{bin}/jackett --version 2>&1; true"))

    port = free_port

    pid = spawn bin/"jackett", "-d", testpath, "-p", port.to_s

    begin
      sleep 15
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end