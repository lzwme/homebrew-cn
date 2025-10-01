class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghfast.top/https://github.com/crate-ci/typos/archive/refs/tags/v1.37.0.tar.gz"
  sha256 "e95e9a3975ce276e3e470a416420c1b5ed4dab69d924c00fe94cf59df2c9e3d7"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e77b92c15b244a06b250ebd77ef70c72b7b1bccf30fbcf6f0615815659abfe75"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4d54d6a6dabc20ecebcf8a502fdda66363e6fac4ac5b54e16bdfba97eb5dc13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a74bf7b3e50fc51a1f600d1f9b8366740bff99bb96fccec6f23ba78965aa5bce"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a9269e3f9f720b19d69e105080af71412cc26596983623f53e75c2357a9fe99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1784e110f3316b88ab6aa0256234622ec5bf9a621d25f6cdee5ef8cbd65e6c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0a3f4d2da3d3dfd46ad95a184d61d319eaaaa5e9b0ba59a501881bf66deca83"
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