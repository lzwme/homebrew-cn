class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.23.74.tar.gz"
  sha256 "e2dc2539fd050be7f99368e2063cc67c56a4085ff55bff8650e3ebfdf86b0197"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "74a20770427024bcbc7f90ed4bd8f75861c5110fb49e0928c8b1fdec7d5bfa6a"
    sha256 cellar: :any,                 arm64_sequoia: "c59cb4a72cbe5cfdf52e14713fed678d0e781bac912b9a5297df46cebc75baad"
    sha256 cellar: :any,                 arm64_sonoma:  "fa5c424342cf45e664e127ffd42f14a1a05ef1fc86b450497ae397aee9d382dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ea49942a1589c06794542f5980aa235f1cbd6ea7a188ae38ec32f1ca4f0a969"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12e9787abc4a267b24ad1dd7e067bee3fdd51e5d3d500f9d600fc7fcc3bf086a"
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