class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.844.tar.gz"
  sha256 "7845cd7ba83a808de0aec105d5f35ae1d9802c18112ea6caf1881ea655ef004f"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "41c0692be55ea96262190d2da5203a91818127e05e96bc043c65083a9de1e3d9"
    sha256 cellar: :any,                 arm64_sonoma:  "9486a63f80a091d3c620cafefefd35a90dd7c0f4a2ae35cb3585739f42872018"
    sha256 cellar: :any,                 arm64_ventura: "487301e0cb03157cf1eaa741dd9ddd87408c4bb841c842cef668cdfa7d3b3354"
    sha256 cellar: :any,                 sonoma:        "15f6f1aa4a552be72a5feae15c3183dd29b307ab230f86c3401d4db5e2f9c37d"
    sha256 cellar: :any,                 ventura:       "d4acb2f6a246fc337a4891c2ab02200f92f3a4079b771e67171235deef87bfaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "543bc76b7066e2929dc85028d205ea152470c70dadd83a7a149b7c05f145e2bf"
  end

  depends_on "dotnet"

  def install
    dotnet = Formula["dotnet"]
    os = OS.mac? ? "osx" : OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s

    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --output #{libexec}
      --runtime #{os}-#{arch}
      --no-self-contained
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