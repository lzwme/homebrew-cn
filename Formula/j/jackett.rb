class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2223.tar.gz"
  sha256 "89cd1154529e5f86e2b60e0c812acf6f5abf48fbc61a2c995e36e31bce796913"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0c876907e593434f791d7d2680d3e13c0b5f03c1f3884f860a49d2e270bab57f"
    sha256 cellar: :any,                 arm64_sonoma:  "cb14dc274b4c17f0602d8afe38c5ad664d6e68e4f54575ea39f231471821380a"
    sha256 cellar: :any,                 arm64_ventura: "792c69135f11de882405cd1dfaa1d3d851356d03a24a0f8dbb6cc0d1e7de8338"
    sha256 cellar: :any,                 ventura:       "681554ebb123bf7c6a3ea276bca4f01459fdb1ae89eb3877890480911f994a6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b3c56b1c70ea401e42eb1605460f31060664b3eaa0bd8c17c05834ccd4210604"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "379f5dc3604f38efd6173ce31857078f0ba9075c441185c1cabece3d79a99d99"
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