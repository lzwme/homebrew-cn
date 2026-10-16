class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://ghfast.top/https://github.com/Byron/dua-cli/archive/refs/tags/v2.46.0.tar.gz"
  sha256 "321e06440a8ba5dd05ecfd78904a127c9ffa556a40d886ab5862a9fe9aa9bd21"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "05596039f6decfec05fde8ef4ff60ba076dee71d48e7d6d61dd485ea2f76336a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "88a8bf183814b7d5659e23e6aec79d6ffd7e8de608277701a77634c3659483d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "efbdc550e2cc3be5d280e364edd531f5c8866944ca8b613776f3cce0a6d9e287"
    sha256 cellar: :any,                 arm64_linux:       "90a6aad0bd2e85915761774ee9d4135296b007134a7df4e85c3a9c22cf1a8bf5"
    sha256 cellar: :any,                 x86_64_linux:      "95339cc892b25f900981b0771f679c4b380950ec391d009a9f103be6d7b6b9f8"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Test that usage is correct for these 2 files.
    (testpath/"empty.txt").write("")
    (testpath/"file.txt").write("01")

    expected = %r{
      \s*0\s*B\s*#{testpath}/empty.txt\n
      \s*2\s*B\s*#{testpath}/file.txt\n
      \s*2\s*B\s*total\n
    }x
    assert_match expected, shell_output("#{bin}/dua -A #{testpath}/*.txt")
  end
end