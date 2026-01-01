class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://ghfast.top/https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.42.3.tar.gz"
  sha256 "1afdc9f9ac8dd66a3b4c90f97f9ba0786cf78e8c274f31ab9fe7916876c123dc"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e70668cfd78c0f562bd823f2058e4a0161c2ce03ffa281744054a1205836cf2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84ae0ad8fa25474f6f66e3f105e5935b8bab16815ffcfa1db8cf365c15069b17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d2fadb5ecb89a9651f263f3e817b734dac679919190afb161d4d25cfb9a7a245"
    sha256 cellar: :any_skip_relocation, sonoma:        "50c3f619862ea407a7750b9771ddc1722562d6c1ddda704906629d2add112b5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ef6dbd2f116a65173667634afef3042fb734db31a4e8c8b7bfaba644161db50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b1fbeb85a117301acac428135b513bca3d29a560db726126c973a3e389a6b1d"
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