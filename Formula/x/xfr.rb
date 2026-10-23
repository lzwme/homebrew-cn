class Xfr < Formula
  desc "Modern network bandwidth testing with TUI"
  homepage "https://github.com/lance0/xfr"
  url "https://ghfast.top/https://github.com/lance0/xfr/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "58f525cf039f405ea976b412b720a757867523755fd6c8a3e73e08fb98b35147"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/lance0/xfr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fc4b59bd1e029980badfd73394f9a1d874a09cbc90ec6deb2d0760e1f7c4d899"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7b1af95ac7153522cf4ddf952b6d2257add9286685a93b5d80555e1b29f67602"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2d321f41029bd3abb4573b83cc3d70d1331749ede6236ddd8562883873f2b44b"
    sha256 cellar: :any,                 arm64_linux:       "7514596488566abac454d5c3b6200fd963af1253a30a113b9f090bcda30e51c4"
    sha256 cellar: :any,                 x86_64_linux:      "5818e32b1e738b9e6b2881cf4e3b72467cf5a6a2ec035f499a5a87eee06e6084"
  end

  depends_on "rust" => :build

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"xfr", shell_parameter_format: "--completions=")
    man1.install "docs/xfr.1"
  end

  test do
    ENV["XFR_NO_UPDATE_CHECK"] = "1"
    port = free_port
    pid = spawn bin/"xfr", "serve", "--port", port.to_s, "--no-mdns"
    sleep 1
    output = shell_output("#{bin}/xfr 127.0.0.1 --port #{port} --time 1sec --json")
    assert_operator JSON.parse(output)["bytes_total"], :>, 0
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end