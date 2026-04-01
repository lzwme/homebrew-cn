class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://ghfast.top/https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.46.9.tar.gz"
  sha256 "fb3e8c58074c6483edb7360f64c45ca92624cff8bcc9a315023a2bc855580389"
  license "Apache-2.0"
  head "https://github.com/Oxen-AI/Oxen.git", branch: "main"

  # The upstream repository contains tags that are not releases.
  # Limit the regex to only match version numbers.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dcba7d0a69ccdaaab19e6e3ac179c16b0b4521d89238eb02d0288a1018635a59"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe672b5e107f7b40bf651cc57e3ea9a99266b937e43233b9ef12f9373594dc79"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55ef8be0fdab7f9a132f88b104adceb34170243c8cc65e4f1c9bd28d3b1aec55"
    sha256 cellar: :any_skip_relocation, sonoma:        "2df24353d3c5f9c5da77b26af3537e57d9f8e8fae5e1124e3072aac5e5b01350"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "950ad8e9ba036d5b19fb49ffcf26771785c3fa7dc319179aacfe12daff484f6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36415e724c890dfaa57d49f26d95741148598c9ef75881c030874107c64dab03"
  end

  depends_on "cmake" => :build # for libz-ng-sys
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "llvm" # for libclang

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oxen --version")

    system bin/"oxen", "init"
    assert_match "default_host = \"hub.oxen.ai\"", (testpath/".config/oxen/auth_config.toml").read
  end
end