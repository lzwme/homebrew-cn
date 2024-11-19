class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.955.tar.gz"
  sha256 "cc8d9ba420e3cb194f990c870850aa1a8361485fe96b838dee2d53c2b550d45e"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8806279b5c6395e471a17a75bc039d0bab235aff66cb89bebeccba65013a35b5"
    sha256 cellar: :any,                 arm64_sonoma:  "dfed24636d6d63d47927d705f6cb23118b4a0280825f8b4b069f328d7492443b"
    sha256 cellar: :any,                 arm64_ventura: "d60f3a79961e198b6a94b767441f869412da81a706abd006eb719adbda1eaef6"
    sha256 cellar: :any,                 ventura:       "5b09dbbfadbe10ac745b427413ec2c2913ba36b0037520d7d07a4ea73edc00ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14987243096686573937fb9daa765bb07729be5f0eeaa13e49db8ec837693737"
  end

  depends_on "dotnet@8"

  def install
    dotnet = Formula["dotnet@8"]
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