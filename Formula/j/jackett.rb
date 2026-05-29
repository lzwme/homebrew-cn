class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1968.tar.gz"
  sha256 "f3656b524857729af42e68dded5d0db54d59d46d6302b55069aece421f75887c"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "aa30fb64ca2459a7d21825107f5d8351c8dd792b3f3603edd052c24e85c7b505"
    sha256 cellar: :any,                 arm64_sequoia: "1338068d39ecea482b8c1e98cd92e2eba5cd44bbebf6c0e81ebd250d2193ace2"
    sha256 cellar: :any,                 arm64_sonoma:  "364c51b50c0a4daa395d63618eec5ed69ef6e3d858997c46dee7771cdaa8c3c8"
    sha256 cellar: :any,                 sonoma:        "342022f445a9774e5fb3e74c982e2ee1dcaac60ed2e4410ba019e0bac097867b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbab2e4e626efc0a44a224b5ca2fcd2ada651407865eeeccf5a7e3ab9fa5a9a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "435da7144c76d060a2f5aaf4bdc688853cebddad0735dfbd6c97f3b0165374e0"
  end

  # Aligned to .NET dependency. Can remove if updated to latest .NET
  deprecate! date: "2026-11-10", because: "needs end-of-life .NET 9"
  disable! date: "2027-11-10", because: "needs end-of-life .NET 9"

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