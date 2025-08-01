class Dexidp < Formula
  desc "OpenID Connect Identity and OAuth 2.0 Provider"
  homepage "https://dexidp.io"
  url "https://ghfast.top/https://github.com/dexidp/dex/archive/refs/tags/v2.43.1.tar.gz"
  sha256 "f3b97c0315cbade7072a2665490db2e8cb1869d606f47a63301fd1c5bf568179"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5dab612925a5bd5df8fb5568ff8e4518d065df80f3f8a97f733d15e3e3ff2e02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ff25f73750917d0a3c0fad7f3da97c795a78f577a5ca6e81f78195a5f5996d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b1dfbc438df4649eaa41f79184dd1e9a7db9c959358f5ae75ee90eda06ecebaf"
    sha256 cellar: :any_skip_relocation, sonoma:        "36248b5904adb1e060f09ed27a7a84b966436e7c41cb7ff58576800bc952b501"
    sha256 cellar: :any_skip_relocation, ventura:       "a5a41bc11c26692df5632ee4c7749a7b7afb8ef953baac8780f799e4ca180737"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4bd51c389c1a0ad685c5ca313efbdb7f70c6dcafea005ee12078fdd79906196"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "216d6cb44634e1126d93a34022f848332a06a6432cbe090406312658ed2d9383"
  end

  depends_on "go" => :build

  conflicts_with "dex", because: "both install `dex` binaries"

  def install
    ldflags = "-w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"dex"), "./cmd/dex"
    pkgetc.install "config.yaml.dist" => "config.yaml"
  end

  service do
    run [opt_bin/"dex", "serve", etc/"dexidp/config.yaml"]
    keep_alive true
    error_log_path var/"log/dex.log"
    log_path var/"log/dex.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dex version")

    port = free_port
    cp pkgetc/"config.yaml", testpath
    inreplace "config.yaml", "5556", port.to_s

    pid = spawn bin/"dex", "serve", "config.yaml"
    sleep 3

    assert_match "Dex", shell_output("curl -s localhost:#{port}/dex")
  ensure
    Process.kill "TERM", pid
  end
end