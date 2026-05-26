class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1947.tar.gz"
  sha256 "d69ddc5acb82656d7f5d4fe1b078c9b2755e79236fdb402e3c818e6570d2b4a0"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "de092021987242dc84a816d4baded3c33454ee9413be449f1862b9b40fe49d07"
    sha256 cellar: :any,                 arm64_sequoia: "071c4442ea56edd7852d493027a76358dbf406d9d0ee1e41b3cc3d1d2129cb9f"
    sha256 cellar: :any,                 arm64_sonoma:  "b699fa52c6c3504a3dd31c10c61bdc016098cda30ae8ef40c01b9daa9819ef13"
    sha256 cellar: :any,                 sonoma:        "3ddd24be43987b8e9841cdf05a5aae1738d0940121b2578f07add53275041081"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9351aef71d8ab9afebc9e376d5a87e7d0ccc4202fb0124cc2040515dae159f6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdec4ec21fae9586e8ef6693e3b9bd057c678b88eadfaa29955d701571702b11"
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