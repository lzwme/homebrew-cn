class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://ghfast.top/https://github.com/fatedier/frp/archive/refs/tags/v0.65.0.tar.gz"
  sha256 "bbec0d1855e66c96e3a79ff97b8c74d9b1b45ec560aa7132550254d48321f7de"
  license "Apache-2.0"
  head "https://github.com/fatedier/frp.git", branch: "dev"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f3053a5843deca96265304ff627b1c7b6951ef6abcd248a12ea12756ac0c465"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f3053a5843deca96265304ff627b1c7b6951ef6abcd248a12ea12756ac0c465"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f3053a5843deca96265304ff627b1c7b6951ef6abcd248a12ea12756ac0c465"
    sha256 cellar: :any_skip_relocation, sonoma:        "6fccfe49d437feea557993d1b0a9f90b4326134e458d2c0af62de5c89578e881"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7b07ac18033aca3a8f2b95ed2ec66bd38cbab7340e1d8600351f66ef3aa61e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61f78b1dd179993df4d3ec3fe67c2fb1e7ad1ffc1ad0a8db21314b7744a07c39"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w", tags: "frps"), "./cmd/frps"

    (etc/"frp").install "conf/frps.toml"

    generate_completions_from_executable(bin/"frps", "completion")
  end

  service do
    run [opt_bin/"frps", "-c", etc/"frp/frps.toml"]
    keep_alive true
    error_log_path var/"log/frps.log"
    log_path var/"log/frps.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/frps -v")
    assert_match "Flags", shell_output("#{bin}/frps --help")

    read, write = IO.pipe
    fork do
      exec bin/"frps", out: write
    end
    sleep 3

    output = read.gets
    assert_match "frps uses command line arguments for config", output
  end
end