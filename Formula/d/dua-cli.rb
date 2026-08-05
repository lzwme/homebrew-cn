class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://ghfast.top/https://github.com/Byron/dua-cli/archive/refs/tags/v2.41.1.tar.gz"
  sha256 "68a37e947aa19d2aeed3f24180e6c52017a7c185677456acabcde38ce10cbb9e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7edde17d858b27d288d38deab1161a3d6726dab8803b04b77219c0acb5341b05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "099d8b8ae540e1125f4899ee636dc319e1c1da507074a126cae2da4499adaa75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7a46e8074ee717725922646b84d782cc8349c36c9fcbabd078672d31a1c5723"
    sha256 cellar: :any_skip_relocation, sonoma:        "261228c97d483ea2460096ea806c0a965e0eae76f830c0e80d56946816f21bad"
    sha256 cellar: :any,                 arm64_linux:   "c1e28f3c0800bb73819be1deace51fd9ee220a74cf501d2d3a05207d9c338b9a"
    sha256 cellar: :any,                 x86_64_linux:  "50b1e9e17f4fbeecfd551466e560987875f6a2bcd98fd0fabfb130cc7c1f9479"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Test that usage is correct for these 2 files.
    (testpath/"empty.txt").write("")
    (testpath/"file.txt").write("01")

    expected = %r{
      \e\[32m\s*0\s*B\e\[39m\ #{testpath}/empty.txt\n
      \e\[32m\s*2\s*B\e\[39m\ #{testpath}/file.txt\n
      \e\[32m\s*2\s*B\e\[39m\ total\n
    }x
    assert_match expected, shell_output("#{bin}/dua -A #{testpath}/*.txt")
  end
end