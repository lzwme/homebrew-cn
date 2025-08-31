class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2374.tar.gz"
  sha256 "fb8e551a9bd41de1fd67226cdcd6fcdf49e9786b439e3c3e284bc501f0097c3f"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a9f9ea1e2550cac0f82619eead868a32ee46711f16140328d59ba5b626a21d29"
    sha256 cellar: :any,                 arm64_sonoma:  "e2b510cf2e5192da34fff8396f5e1ede1f1841616c023a1ca210230bc1bd1f7b"
    sha256 cellar: :any,                 arm64_ventura: "f2788fa03905b6c7fa62a615a11d27bd35abfd0e11323ea5bdef057c7e4a7c05"
    sha256 cellar: :any,                 ventura:       "996342f28706f6ee50c50b0a9a12d454557ae212453df0dba56fefad3bfa9e6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df6536603972936230180fa1974a17231a217666639c91279d170915b42b6ee5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8a8fa5461f6d866c7edb80138dd1b593a4ce75ffe8f96c2921e3d3b03a170ad"
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

    pid = fork do
      exec bin/"jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 15
      assert_match "<title>Jackett</title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http://localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end