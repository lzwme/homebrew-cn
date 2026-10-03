class Sofka < Formula
  desc "Kubernetes TUI, reimagined in Rust"
  homepage "https://github.com/nklmilojevic/sofka"
  url "https://ghfast.top/https://github.com/nklmilojevic/sofka/archive/refs/tags/v0.29.8.tar.gz"
  sha256 "76a79957b5aeb0717b0f0c3ec78e757a4a79a14052141831027e7bfbf7962bf9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c5066be22bee9e5d000bacfaeaab7c3d91707413c1dbe9ae86df4a511b89073e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c3e3277f772d62111aeb7dadc9b09473dfff12f3c239220a68b2207fc5022296"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9be4be5d80fe2097e39254296a6f3ad539819e6b6b37a3dcc477ba040e8db8e6"
    sha256 cellar: :any,                 arm64_linux:       "6fbce97248e96774c97925746245494e7653e426c7dd2774869bf93a5d1287e3"
    sha256 cellar: :any,                 x86_64_linux:      "74a3ba6b49a2085ffe52623a47306f97328b44eea54a5115290fd1fce3a31790"
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