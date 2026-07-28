class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.2277.tar.gz"
  sha256 "71667a30e0ca3052298906ef4db59c20883426f54bd57ad44861ccd3e1b9bfdd"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "dd141d4412372fbb25d8dbfacf02c6802f221fc809235236e101b2554c3d1a1f"
    sha256 cellar: :any, arm64_sequoia: "efcadabfac2705017d324e520d0129f40c8f729f27fc20bc64ae433579f631cf"
    sha256 cellar: :any, arm64_sonoma:  "b0ed2d2ba0491bc1db3b50b50dcab35f9bb3e5b8656251beca2395a1868c7b00"
    sha256 cellar: :any, sonoma:        "b9d2e61cc45d2e5a6cf629168d9216531cb9ea632c48b0e3150cc6e7fd7004ce"
    sha256 cellar: :any, arm64_linux:   "daeab34416ced76228bfd815c67220ec09cf41135448e25a34b22e9a84197328"
    sha256 cellar: :any, x86_64_linux:  "d471a9a93dc65ca98c73eeb48a9dccb71106b01c8ff56f653a39b022955551f2"
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