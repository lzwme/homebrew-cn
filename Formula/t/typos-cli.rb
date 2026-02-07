class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghfast.top/https://github.com/crate-ci/typos/archive/refs/tags/v1.43.3.tar.gz"
  sha256 "2be660168e6d1fa4ab0170b14fc605d1418627314cb23379977a65193cbec07d"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f72e1d5a0c80194b6e4d89f9f5d34dd8bd5426641a078098e25b88428ef99f85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18c21bd0ecb45807b74b29bce164a4ce07edd6feea4b252256c40e99404f112c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3302791991bbe3af14576b3c48de8968321e56e5dbbaa04d570793a231f8cc21"
    sha256 cellar: :any_skip_relocation, sonoma:        "2056ec6b41f85555be6b9867ddff8ef7dd7309dc406b464565e99ba255f0adb0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80ab1455fb73e7808866eb91a8106c47b43735b0e4181b5e8cf432fdce242956"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d72b67349eed0db1fe54da202e73293a7dff578d20cef4b0d4038508705cba4"
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