class Xfr < Formula
  desc "Modern network bandwidth testing with TUI"
  homepage "https://github.com/lance0/xfr"
  url "https://ghfast.top/https://github.com/lance0/xfr/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "dabff0fffc4212b3a866c7c7f828ee6830deb4a37b5fade144eba84c3c806be7"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/lance0/xfr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5bd21ba95952b15b46c0983c1153d471bac021d6d98aeeb0a8c054bf33114ecb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4282978c3e67a03b19715cba6318033ce75161f4c957d722ad762b4aa02b8f53"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "874614e7c5ed469c6e8b210207abb03ad9cbc639f9adc4e8ff8bc52d42f2c452"
    sha256 cellar: :any,                 arm64_linux:       "fee85d215832ef37d8aa71e6984bc02f562f7acb533134a5ed4f91407127d13b"
    sha256 cellar: :any,                 x86_64_linux:      "a49019e596e1bf226fdaa7884da09141881e099d635a870fe7f0d7a124ae6978"
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