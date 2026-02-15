class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1113.tar.gz"
  sha256 "949ceb20da98b938da255a5dfac982a234aac8f0a3ead102b12e97ae68ae66f0"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "60ec5a5f54be30947e5d6de2db98148c22ec63bb4a406f59d16d493bab46dae9"
    sha256 cellar: :any,                 arm64_sequoia: "4cc14bbc88a655c07c136c3c4052311fa07dccf5f42225c7bc7b0b9d72cc6ae6"
    sha256 cellar: :any,                 arm64_sonoma:  "b8c644e383fcd1feaf72346dcd43e40bea99aaec0d0ca15772a81e47e3e69c5c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97329fa5824152822d456906a33fec9b62369c8d5ad23f873d418a29f928be87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a326577212857ee92884c39a8666cdef71a28c71690b6b6296977dc5e181ec33"
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