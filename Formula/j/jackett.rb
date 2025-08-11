class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2256.tar.gz"
  sha256 "5cfbb8d6c362541fd7033bd18a205720f566889d1db8e627c14bf796f2153b6d"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fd1ab54cf07fdc9a1f97014b570d2cc60d524224c04a5d60fb8ef027fb77803d"
    sha256 cellar: :any,                 arm64_sonoma:  "0fdb4aebb8c03fa29a4d865e2fd6b088ae98786671caab7212997777f6a8fcf8"
    sha256 cellar: :any,                 arm64_ventura: "5f894776f0d284335e511fa23b41a260ed3dc12aa8d0366d2a502d823660909e"
    sha256 cellar: :any,                 ventura:       "8f894a9bc0e39fe6f30483afb9e06eba9a3e6f5038fb7c1c75c1d17a505c9067"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4829f4b14ed849b0842f0e6b55ec14b0bd71fc0d261ef8de491ada17299f8a0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5632ded12c2f0a71fce1a882ded9cf4ade34cac81c8196ead01affe6c57fec5f"
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