class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghproxy.com/https://github.com/crate-ci/typos/archive/refs/tags/v1.16.15.tar.gz"
  sha256 "8211b7e57bdfe088a8242aad89eb2b16ee734376f4a3540d820f6be7c2e760b1"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "075429c1e83666fa853794a5fce59a0835d09e7fc7f316afffc060d4a8a7a060"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d55d41b9e1e16eff3f32abdfee835d41610a6e71ba2adb6f672e20a566fbb63"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee4badbde8ac4bde6db306456da17bb3723264413ab82dbe653ea4a4c92d615a"
    sha256 cellar: :any_skip_relocation, sonoma:         "5554b7c248d74729e11a883599bf1db95462bfe60c50d01a9618c0f2dc5e41b2"
    sha256 cellar: :any_skip_relocation, ventura:        "57b3c4cb169d4af61b712340b0106d3d0e00a2dac3c5c07d8b664f1de9e8ab5c"
    sha256 cellar: :any_skip_relocation, monterey:       "f6e19caff4470dba2d852bb879ed7e13fbedd47678f3936107efc317dd7a67f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7acace5c3b08689d6291e1fc0ff568aceac2e6d520c9c4299d3f320b1ec92ace"
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