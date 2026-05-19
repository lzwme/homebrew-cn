class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1879.tar.gz"
  sha256 "1a8b10322016788617524b16323ae76e84523e65c70f624aea19f07788de9957"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bf05d54e28ad69161a7c259dfc33a282b5955c75620ba0fc543ea48c55c29247"
    sha256 cellar: :any,                 arm64_sequoia: "f3abdf81adad383f3a6379326c48892e8574dce807e26e7a93ef1497a833d907"
    sha256 cellar: :any,                 arm64_sonoma:  "1bc61b1b4aaed9c8570c6be50622b2a12e43077129604382c0e1e2c12470c0f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10485b1bdb34ff8d106c83969bd5f68ec1859fce158f3ff18d66fca873773093"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94b35aa16f6e627c034c428a1813c78a194d4e414049e6b6c88e236edb1b9c76"
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