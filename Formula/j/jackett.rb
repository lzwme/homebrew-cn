class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1167.tar.gz"
  sha256 "340dcfc30b310d3d0a69126db0e1dcbd14346d370f4d968ed47125b38d9b570a"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c3b9c3f9ba8d77e743ef4b3e9a343d233270bc2af55140060864ed7089377b11"
    sha256 cellar: :any,                 arm64_sequoia: "b3a2f8450825df3f26111545ff8a664369bb4253771f382c3f87cfa0c3d89909"
    sha256 cellar: :any,                 arm64_sonoma:  "35716a9f6afa577ad64d69e01a54b5d32b8870b049f279538826aafdf5e1bbd9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e632a190c97b773379127d935586f2b696ea1b4dd125630fb17ee41b91a1b86c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86247be53384aa42243925b7c724b2258d37da7a436637e4b66a190aca47b8d7"
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