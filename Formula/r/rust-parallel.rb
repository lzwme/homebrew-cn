class RustParallel < Formula
  desc "Run commands in parallel with Rust's Tokio framework"
  homepage "https://github.com/aaronriekenberg/rust-parallel"
  url "https://ghfast.top/https://github.com/aaronriekenberg/rust-parallel/archive/refs/tags/v1.19.0.tar.gz"
  sha256 "73c71fccd95d427339275b731ef697997cae963f9c2ad1c47535063720d781ba"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9db8a469396e23073950fa244b71708499dced4aff1344f1444aeee0ae9faa2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b85636251db1aa2b7b736740a2c1e65600e697b5cae2582eadfb2465488491b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7c11482e2fe822999a1f5f57b358bc19a17bd27812f22659c7fd13ba52041fb"
    sha256 cellar: :any_skip_relocation, sonoma:        "bcd347ee6a1eb1d736d6191148a61a53b49cdce6c918239eb147c8f0876ab30e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5771f8e6af978ac3bb4f1c6910190fca0f3415f5b4b334a7581838dfdf43f1e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96c2a35d1bbfea8d7eabc349666569e6375835c2b09450f75184ce6c2a3cd16f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    testdata = testpath/"seq"
    testdata.write(1.upto(3).to_a.join("\n"))
    testcmd = "rust-parallel -i #{testdata} echo"
    testset = Array.new(10) { pipe_output(testcmd) }
    refute_equal testset.size, testset.uniq.size
  end
end