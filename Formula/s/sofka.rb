class Sofka < Formula
  desc "Kubernetes TUI, reimagined in Rust"
  homepage "https://github.com/nklmilojevic/sofka"
  url "https://ghfast.top/https://github.com/nklmilojevic/sofka/archive/refs/tags/v0.29.7.tar.gz"
  sha256 "a8eb736b798089a49e86b01fed3157e35a83bfac257832df8b44a7c1a5e77916"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "27c27c6b88a25d3276a53eeda9751cf22467a03b5e8c8f604cb63915012019de"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "132f22b620f6c459a76ea2365890011012b4bec886ae3789990c5207e5d2dac4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6a52bd25460b346c476573b67353def2065060e6b12992d55882614d0df80c95"
    sha256 cellar: :any,                 arm64_linux:       "8ab489e7f91849257084a22123c00bfda5ff3b9de25b80e8c05b323aa237b23d"
    sha256 cellar: :any,                 x86_64_linux:      "0cb8ab13dedc16e7add747adbf9a4def99ba2f8bbdc243aabb0f3f3e97df7f86"
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