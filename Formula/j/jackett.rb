class Jackett < Formula
  desc "API Support for your favorite torrent trackers"
  homepage "https:github.comJackettJackett"
  url "https:github.comJackettJackettarchiverefstagsv0.22.372.tar.gz"
  sha256 "c02517baa9872ac102d09a38a5984a419f80f30b235a5372509d847d4ff8589d"
  license "GPL-2.0-only"
  head "https:github.comJackettJackett.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6430cfe796ca26020019570f421b9151dc090774d3c6c4a60d3110c62d99dc81"
    sha256 cellar: :any,                 arm64_ventura:  "b9b1e8d3b3a78a9791ebd3614a156767e6811ff5a84a9a49249ad362ba142227"
    sha256 cellar: :any,                 arm64_monterey: "9e2f116d263bf56ddbde38126561adc7c9657d665096924240beb58331a47554"
    sha256 cellar: :any,                 sonoma:         "0a1e379863b4ec85a64c094a8f5c1903bcba0669d66b0578b4b5c4963a1e8b72"
    sha256 cellar: :any,                 ventura:        "702e9ef2a7a6d464b514a479f3c07b1218c177e6d854d6c47985bc5a4aec8541"
    sha256 cellar: :any,                 monterey:       "65089b2cc213e643ad986aa651d94e027bdffc3791a8335f7426ffcfa6ec9e78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c53b6adc057d91a5f1ea0ed704b793460fa1ab2ba7dac71c3dee6fe34be98896"
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
      exec "#{bin}jackett", "-d", testpath, "-p", port.to_s
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