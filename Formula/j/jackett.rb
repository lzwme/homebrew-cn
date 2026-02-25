class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.24.1193.tar.gz"
  sha256 "dd6afc209de296d72525dfe3777d1b53ca900ff4d0fdd66b618fae4773b6078d"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "58e93fc38bf697958af8160b76f8d3fbcf26fb0982494513022187f90b007d91"
    sha256 cellar: :any,                 arm64_sequoia: "7b6a4f155aef520b1afe9870ce7c3b285e7edaba99694c333758c183a5a60c71"
    sha256 cellar: :any,                 arm64_sonoma:  "c995ed0ca4c697e6717db31eab7ef534901b806361a2972c92987dd4d3cc3255"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0869ac79ac6b0124b4f067ce86abb140ea7679ad9a33a1482e8fc90090c9bbed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82d86464c31f9f5e0160254e7f75107a15b27e35aad36be3c0fa3c6e7e49574f"
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