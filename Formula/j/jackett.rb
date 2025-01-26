class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1309.tar.gz"
  sha256 "5c4aa8bbf94ad4cab64bd3bc39e44d92d9b69b93943c03c2562b9caf0c9ea224"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e253950e42c24f03343243f9953d66e99d61fb3e6b46f16767518ba724674530"
    sha256 cellar: :any,                 arm64_sonoma:  "1cb42631ec353429e5922faf85fb438d15b17d3339ef47042e77cfdbe8a623f0"
    sha256 cellar: :any,                 arm64_ventura: "5bc9ac2ec390857e3157a750228db0b4860a290945f5ec07991031bb79fa56a3"
    sha256 cellar: :any,                 ventura:       "0524db386397c81894c2216596d5d7f267fd3e22c0b0bbbd6cd06c33afb80865"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e2034939a37560c7bb96c442a63a4572962eab482484b18bfea8f31652593bd"
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
        p:AssemblyVersion=#{version}
        p:FileVersion=#{version}
        p:InformationalVersion=#{version}
        p:Version=#{version}
      ]
    end

    system "dotnet", "publish", "srcJackett.Server", *args

    (bin"jackett").write_env_script libexec"jackett", "--NoUpdates",
      DOTNET_ROOT: "${DOTNET_ROOT:-#{dotnet.opt_libexec}}"
  end

  service do
    run opt_bin"jackett"
    keep_alive true
    working_dir opt_libexec
    log_path var"logjackett.log"
    error_log_path var"logjackett.log"
  end

  test do
    assert_match(^Jackett v#{Regexp.escape(version)}$, shell_output("#{bin}jackett --version 2>&1; true"))

    port = free_port

    pid = fork do
      exec bin"jackett", "-d", testpath, "-p", port.to_s
    end

    begin
      sleep 15
      assert_match "<title>Jackett<title>", shell_output("curl -b cookiefile -c cookiefile -L --silent http:localhost:#{port}")
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end