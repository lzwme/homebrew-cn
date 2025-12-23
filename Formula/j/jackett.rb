class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.504.tar.gz"
  sha256 "ee8f0fcfd0fb535f64832f07b6e33e8feaab3f1c66854e7e60333af8dbc27674"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1530780561f869ddd2881ca346ebc8298bff1dcbc3fccbc3024f6adce8b3f338"
    sha256 cellar: :any,                 arm64_sequoia: "b0df5ef9750179f6f9987ae328ca05106231f475d8162c93383b310ebd053eac"
    sha256 cellar: :any,                 arm64_sonoma:  "b56bdefcd24ed32ec84d4db9420c34bfa47d5907d849b9edf225d5591cfb0480"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3bfdb263164a93c8f42f2ce4b5848da6b34866cdf35629ae576e22ee43fb018d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02daa62566862f247d4c0275e2efed720fe5793871e58396980f604ad5475cec"
  end

  depends_on "dotnet"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"
    ENV["DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"] = "1"

    dotnet = Formula["dotnet"]

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