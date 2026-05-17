class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghfast.top/https://github.com/crate-ci/typos/archive/refs/tags/v1.46.2.tar.gz"
  sha256 "1b239ce3b52a5e720d1f6028fbf60c0fab7f5617cb2ccb3d7e00f7e5a752c62f"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4a036d15031b8f13489ae7e0e0edef9ab445f81f3d4635dcba3d39d2201ad03"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f58d90a2db78daba32c76cf1052d10eba79e2ca229f487ba0dc1a9dfc7287fbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7fc9a5e2cd78d4aba192e4a693eeeed9b1e63e94a0abc10128245b5a73948745"
    sha256 cellar: :any_skip_relocation, sonoma:        "a151c6777aa1866dd3a69cf5693b022ba0740e771b53eb0e1224ae9a8a13024b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "676a95a5f7d4f48cb2d88551a1275b621da9c071e220c6bbfaff08888e87abe4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db79ca031aecba595f1fab94d63bd43a51814975e679052579a7d24911a610aa"
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