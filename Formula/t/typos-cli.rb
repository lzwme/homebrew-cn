class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghfast.top/https://github.com/crate-ci/typos/archive/refs/tags/v1.42.3.tar.gz"
  sha256 "d1b5fcd3ddc49c279c1813086e80dabb6a524d9fb67befb4e3619d236ada5781"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5174941cc19e75d6dd1c891b9d1698652f7f49b6dfe4db755cc7b1af4cea4145"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23066af8371f1b65b107da5e6b9574d0953f8cfd7828d52cb0f2339d56e39f11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0cd106ba5f5b6322eb087adf78297ca02a2a840575429cf92d2a0ce6a13b63cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f05a42222a117c7968c2e3af134f7e7276bf4e3748a3d0ede84e7d38eea1cb1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd289961f060563241e80acf77ef32fa4e35ec5510f8df04fda3d4e38fff11bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e3bde833d61d2eb947082c00a950ba7656fa70f34d5edc3346bc5c6eaeadacc"
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