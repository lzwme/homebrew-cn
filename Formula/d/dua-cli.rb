class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://ghfast.top/https://github.com/Byron/dua-cli/archive/refs/tags/v2.44.0.tar.gz"
  sha256 "84fcc09a982542037e990bc3cf861b2e6ef34a556ad45552eceda3bb02801566"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e0bf9b12f3a63d2bf57b0d1e8dcebb34c947dc6e3e94b59cdcf1f8a575eac2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ce5872ef30fb219cb7867e85e4154e6e47b4467673232f91d1243d15ecd6315"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "97ac4a94c997f53ce832459139e4a6d8b812f05289265e3423ddc3f9f97f9c75"
    sha256 cellar: :any,                 arm64_linux:   "deefc77f39f600b4f1ebec8e49001c62cfdb5f8b9a7e9b228cf505ab55332fdf"
    sha256 cellar: :any,                 x86_64_linux:  "971b6cf25e87a97c221bbdf8b078bc3802b73360d23917ce8116048644c4072e"
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
      \s*0\s*B\s*#{testpath}/empty.txt\n
      \s*2\s*B\s*#{testpath}/file.txt\n
      \s*2\s*B\s*total\n
    }x
    assert_match expected, shell_output("#{bin}/dua -A #{testpath}/*.txt")
  end
end