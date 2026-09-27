class Sofka < Formula
  desc "Kubernetes TUI, reimagined in Rust"
  homepage "https://github.com/nklmilojevic/sofka"
  url "https://ghfast.top/https://github.com/nklmilojevic/sofka/archive/refs/tags/v0.29.3.tar.gz"
  sha256 "a6bfaa1b951068be28f35910bc8556a3fd1b9e810ee4c428628dad0cacb98664"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "805c009fe611350307151ac1ac4de10137dfedf6eb7452d57c3fda1ca1c5da08"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "22d18288f7bc3569ff64066d566c181d5981c7e137bce899ca8f95c59a870a22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2b563c66e648cfd4a2d3f559ae65885b1f708cdab1313711483045c4cb14eb36"
    sha256 cellar: :any,                 arm64_linux:       "8d6579ac712e9f9261bd5e09f181a9e9454836c9eae4dab9de4d7728fda15d04"
    sha256 cellar: :any,                 x86_64_linux:      "8dfe8a1151ea630c07744af83edd9ef35df8185e284cc577b202eb12be161d0a"
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