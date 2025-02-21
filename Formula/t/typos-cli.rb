class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https:github.comcrate-citypos"
  url "https:github.comcrate-cityposarchiverefstagsv1.29.9.tar.gz"
  sha256 "39950d1f2744cb5fec3780b7894aa8074af74195029762b84ab728c12b4b4548"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "861412fb55049441e8c16c882f8973b0d4eb1419f54998e29e56cc04fd171cd6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1bd90e5cf93372a7e69079a0c676939420b938a2b2cf854ac56850209d8bc2b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b9245f08f128f9fc3ecbd641bec0e4e3b4fa7722fc71eb67be8f774eab3bddf6"
    sha256 cellar: :any_skip_relocation, sonoma:        "396084f88ffdf2d2fd7b55f8d0092e49448f5e863f59816343a72dcf7f1670a1"
    sha256 cellar: :any_skip_relocation, ventura:       "c4e38dba825290a8ff95a56ec35b3649a92dfe9428699a84ff0fd5b5c65fe19d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5e768297c6e3666b0b5cbc86e5db4bb64bbe7e774ca89389dd741c191a02ad5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratestypos-cli")
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}typos -", "teh", 2)
    assert_empty pipe_output("#{bin}typos -", "the")
  end
end