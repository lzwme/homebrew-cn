class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2178.tar.gz"
  sha256 "8a0d7be3d638014ed77ccbe0f6400ccd2aec6af5ab24663a885cc658e613734d"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cb0465fbb6a391150706e9a6df386e96c708939cc4710c35999e797c42e1568d"
    sha256 cellar: :any,                 arm64_sonoma:  "fa08feb69acb6a4f13a4df42f725396ec02e281b84d99c23a73c493652295e31"
    sha256 cellar: :any,                 arm64_ventura: "340482c920983eaf57897c05ea454377bf81ba19e9d147edc4dcc8e543538ab6"
    sha256 cellar: :any,                 ventura:       "39477a210f40678aa350a985307965779b672b9c47e754454a3450f476d4a17c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fec31efdaf19682ee321ea63381be4eefbce8505f8657a62fce8a9639afead8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f09019d7cf67a996481121cbd09364f399b8c74067d9cf4cc64b784ca15fac0"
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