class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://ghfast.top/https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.42.4.tar.gz"
  sha256 "e61ef588394c63be93c6629c6f910d7dc282e984d05d9b95ae7b98b3dda3705d"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8bf78876970b987e481dd9b0732229f0ad2222c5f15860018314140cd33aa2f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4364d24e065d8a6046585a26a116feaef056b1613aff30f1dd14eb735e27a6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "567692d73ff179354ab1d3a79bd3ea4527960aa75207e8f3273fe258c94e83b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "95d0597d4064106746177ce02bf2559d07104eea00fb1c6a6df42af4324a0e23"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3c901a1e7e7bde387e3a261fc4ab180e71df5895cfb7809c19d3aded337af11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a374fbb8c6a9f9b470372f3ddaedac20516b35a98b3d239856e7a378dd599a7"
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
    cd "oxen-rust" do
      system "cargo", "install", *std_cargo_args(path: "src/cli")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oxen --version")

    system bin/"oxen", "init"
    assert_match "default_host = \"hub.oxen.ai\"", (testpath/".config/oxen/auth_config.toml").read
  end
end