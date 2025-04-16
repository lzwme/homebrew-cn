class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.1778.tar.gz"
  sha256 "886a692cdf26bee7371b93056e9fb1c9ec8270388e1e1334550c2ee15d3d7e74"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "32c32999bcf92f406748ff9fdb32c99b82e3ebc79951e594ded4cb72bbf0ec5f"
    sha256 cellar: :any,                 arm64_sonoma:  "c73d27ba76dc4f324afa18a480043585b4f995639945a093476c14a5f47ff91b"
    sha256 cellar: :any,                 arm64_ventura: "c1971148f98a7c68457ffae5e249dd54d52cabd3e9051b656b4051d97281f21e"
    sha256 cellar: :any,                 ventura:       "2a515558cccd701e61387722379251d8d3ac31a1ddd496f1d2bca3c9af9d6da9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eabd7337da5eeb6e07484136d7dc198c70f8eee32b47e7db17e7b55702877303"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7aec6277b90ed1b06c93cb7403d5094c2748935e617d14a225e89d2a44e2971"
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