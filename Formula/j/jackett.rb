class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1044.tar.gz"
  sha256 "98002d021829f839e0ccb80f25cf1861475fdbf7680783a2f9beb832ecaf750f"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "87bc146a68d5d6801aa025d32d73dd259b434f92854bb5fc0b5ccff5924d39d2"
    sha256 cellar: :any,                 arm64_sequoia: "7584cc4f1bb345f4d880847d582ebfd93fcaf791c943416d8b069e9d00f41575"
    sha256 cellar: :any,                 arm64_sonoma:  "3fe4671e55ecc8053c568c2297ec8d7ed6d2ea72de18ed970f318710e219fbb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd4bd91cfdddb0a1fd3af520927c19e1c0b074dc3889b68c3b3f5f0620c40127"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df92d64128c82570828ee573b23a5342ec717ce07a5573c17dbf32969f8e4956"
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