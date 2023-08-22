class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghproxy.com/https://github.com/crate-ci/typos/archive/refs/tags/v1.16.8.tar.gz"
  sha256 "d59a1c716ea8c7cdea7c5395b53886b66d0be3154b56576ea0a8f9aa18293457"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7fc0c457d04aa93a6396e954e59bacb124773dbd20c9858bc3131f94cbc0231"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f879515e4f044f93845f6cfa8f141d064c2aa8c10526e7ad2ddc9c398e1fa674"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "285be19e4d3d67ed44f4a43383c59b823d1922644cc775e19220331eb4b76424"
    sha256 cellar: :any_skip_relocation, ventura:        "4d54a16f308d640cda9d34b2cc1f3305826d472bf188b4b704f5277f91da6e76"
    sha256 cellar: :any_skip_relocation, monterey:       "87647597522b3933861aa2d8bd1c3221edf7ef4250c86fc5a81ad663977f20b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "20bb0192b5083698aa6dc79d1751b7f7a8970044eaab542fcb7c04768cf9d46c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c7c7da1b0f309646e404876b2f676392c8a43321ea411503e3fae2834f5489f"
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