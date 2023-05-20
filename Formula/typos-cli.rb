class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghproxy.com/https://github.com/crate-ci/typos/archive/refs/tags/v1.14.10.tar.gz"
  sha256 "766c80cb28f12fd260f280b0c6047d5fc389d06df0993d9edb6146609ff7fbcf"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e10395fe760f46bb969f46e2ff7f7157699bbf9b90912e5b30903cf7c56142fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3e187614fbd5b0e4137b0d85a8dc6e8b28456a2b6b3704af8788eda310d226d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "09a1b8f09533bfd04a5bebe0a626ae7fa083a3fa7b3e3c16ce1b096b1f3af69d"
    sha256 cellar: :any_skip_relocation, ventura:        "25b69fb4e70823533f9017b5b4a6c8f4e43be6cecd2b232876df13fb086d38e6"
    sha256 cellar: :any_skip_relocation, monterey:       "067aa107a745ee27925e9ed0bd8e009304153caf54388d428cb7d19c3fdf53fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "d170d163d55d2b8e73d55db6e6ec93faeab6e532b22ea2e635815985f558ae8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4833c50be66c3cdf4ce143831a6f2fe48e2ae77cd60daa84738b943cff76ae6c"
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