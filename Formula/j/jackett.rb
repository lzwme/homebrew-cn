class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https://github.com/Jackett/Jackett"
  url "https://ghfast.top/https://github.com/Jackett/Jackett/archive/refs/tags/v0.22.2135.tar.gz"
  sha256 "aa4d543ce7264057ae834cd0952d775f915a9269f8236e98da0bbc7986d30c0f"
  license "GPL-2.0-only"
  head "https://github.com/Jackett/Jackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f24bdd1458410711a6194514e9e4483050c531c03c2e20c2b57ac9ab75aab910"
    sha256 cellar: :any,                 arm64_sonoma:  "68bd9aa5ca55484350c6e700bd2b1205b6b6f9b814aeca51366f9a07553f8d33"
    sha256 cellar: :any,                 arm64_ventura: "4ceceda92a53a9dc0315996fd8cdd6102eaeb0f9a7afde4c9b31751a2c4c3b28"
    sha256 cellar: :any,                 ventura:       "4ca18a802b3e13b81875f5ad5ce12d4a7e936531cae32da69d849e9f5495146e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd869679e378575649d76539f06337d81b97d77ac6d693d79f51386affddc13a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "725c8110a29c58437b13e550ad711423b52878939a901274f93f714955b704f4"
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