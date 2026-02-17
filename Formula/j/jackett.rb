class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1127.tar.gz"
  sha256 "6ff1cc6e7f35a1e4dfedfb4ca7b51962a9cb4076fdbee2246cd458790aa6dde5"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "298fa66cc3b5ad70c5e4349f96e87be1c78055164cc6853136a3c633e87e0b7d"
    sha256 cellar: :any,                 arm64_sequoia: "0c1231f33d24f83585abb82e26de7af585f2ee0e1f4e69f6c226f26a0fc4406a"
    sha256 cellar: :any,                 arm64_sonoma:  "3df2be0b8ee66b0c6e368890e936f28c69ea2782680ae979845487585bb84188"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2dd20a014d2aa752c82d5f2dd8d19e89ff170ef9de8a4b67f664065a53453ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf9a0f9b389aaa5e6926c7ab4e46abfec2cf5b390abf59acb05a8aa81505ff75"
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