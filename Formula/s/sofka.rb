class Sofka < Formula
  desc "Kubernetes TUI, reimagined in Rust"
  homepage "https://github.com/nklmilojevic/sofka"
  url "https://ghfast.top/https://github.com/nklmilojevic/sofka/archive/refs/tags/v0.29.2.tar.gz"
  sha256 "d1623065cfab5f6ebb65c4000540c23e498c24b397e9ffd25ff03a809bae3961"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "74e88cfd73789d6dc55a5b1d14d65a5fca0294de8b8c637c7d514586feca394b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "aae91802f7d34d1e3e6ef4b63ec4c639e2ab4c68b12dd159e8ab299aa26468f2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1cf229ed1a24a79caf2daada005a1b834d78d1f045aa4520254ea258cab37983"
    sha256 cellar: :any,                 arm64_linux:       "da64fa43b4e6f355ba2c5fa1638d1cfad6883af67e8d74f3e8d0b01982beed92"
    sha256 cellar: :any,                 x86_64_linux:      "a5897f37a6a8d2697062c4a6f0c14e0fbac9bb63df89e728990dfcc0f7360d23"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"sofka", "completion")
  end

  test do
    assert_equal "sofka #{version}\n", shell_output("#{bin}/sofka --version")
    assert_match "failed to read kubeconfig", shell_output("#{bin}/sofka --check 2>&1", 1)
  end
end