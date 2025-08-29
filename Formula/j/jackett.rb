class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2360.tar.gz"
  sha256 "3a3865a0885eb88df93b28eb35841c5e5b49922e95e6ee84856d4d9371672824"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2bbee6704e85e77f0e050f39945e88ea51a19e03dfea23be8d39192bdf385dbd"
    sha256 cellar: :any,                 arm64_sonoma:  "5c83ef4b57549fbb21c2ed737c64c36f144da3e95549e348c23979e9ef5f38e7"
    sha256 cellar: :any,                 arm64_ventura: "cecd8d0412cc2525b9702616f858ec19b28b11f361d57f0b61fd2a2521154d42"
    sha256 cellar: :any,                 ventura:       "ea2b27638c0c3ae9571317497d7a1275ac774f6e2901ef2a5b09edf07544bf72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53104189e97ee5dd466d78c1ce93ec4bb0e858f800a3a3d4b2fb0f88aab0cb1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af4e292da5582536a37a3e6b276dc4acda995b35379c76d678e87f6235d9f756"
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