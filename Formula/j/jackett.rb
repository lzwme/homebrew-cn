class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2120.tar.gz"
  sha256 "592fd04dcd87aeee6745a8aca4eb933b40005306a63103e1d66679aa557af89f"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0bb1f0b04856c31e26dc8fe8876632910cc22bbcaf8d144e788d1036ee8f8312"
    sha256 cellar: :any,                 arm64_sonoma:  "988eac0abc66a06824161d1dc7cd3def03962d713a231a7778f001089ebaf7a1"
    sha256 cellar: :any,                 arm64_ventura: "6286bb811d0bb6bfe74b9509bf6bf170a9991aa4cf6ae4f0805671ce382fcfa8"
    sha256 cellar: :any,                 ventura:       "91f2479405c225ab3a51c78aea2f26fa4fe36381077f1a21a2a07dd5b9c6b1c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74c8db335c478a010aee1cf2ca2e546e651d91fd694a88519621b9f24bc2810e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61518cb22f08d584a9dedb5f8d216d8a1f25b43ecbfccc8659ef1c33dc3308f2"
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