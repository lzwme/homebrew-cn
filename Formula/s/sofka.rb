class Sofka < Formula
  desc "Kubernetes TUI, reimagined in Rust"
  homepage "https://github.com/nklmilojevic/sofka"
  url "https://ghfast.top/https://github.com/nklmilojevic/sofka/archive/refs/tags/v0.31.6.tar.gz"
  sha256 "54923b829583763923e970155f2cb23b7593fdf523ae3193aca60d0161353851"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d9e20c3ba8445f8b709362d27ace0b687eaf67078799259b0f30b59362f1f156"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ed4687f3a4fbb67c2339f4a05101c907a38430d74d3cd4139f857dfca76c69dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7aeea8a9d684aa4a40ee8e611b5bbd531d81d172ae720af9d99c467ffabc5224"
    sha256 cellar: :any,                 arm64_linux:       "90aa791853374dc091f65e390911b1073a2c77f2df1bd25e4a5a67f1a45dd7d8"
    sha256 cellar: :any,                 x86_64_linux:      "aed2c420d6d671058845fa9e2d9694d3774bcecd309b60f44a254e0b8fb971aa"
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