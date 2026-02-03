class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghfast.top/https://github.com/crate-ci/typos/archive/refs/tags/v1.43.0.tar.gz"
  sha256 "40ac82ce8089a35c708bd5f87f1226bb36d8d10515c74bef78ce002df8a69627"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7b39eb74c9447cc1978a5bdf5a9fa5ae2978ce6c5fa8587d74d9837c138194b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc1488615b74919e54821e1b50752a356a7c53d190647cb20386941fb86147df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1eea41d1c4c4b29f7dbb454a2cea20e8add1329ec41c631ac92ed2473952639e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c87b1ce7847db49b585490bd757f7ca3ef3def5de148cd4c7c27f10fa75afb10"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25d1040864f3510cda1bd37e5b8d9f5419fb25abda416b6f6c414f2d7c9a2d1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b630752a7a5e57d71ad04f9e207b1d101de7a4c51d462c3aea609f1b0e400fe"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/typos-cli")
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}/typos -", "teh", 2)
    assert_empty pipe_output("#{bin}/typos -", "the")
  end
end