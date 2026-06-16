class Plakar < Formula
  desc "Create backups with compression, encryption and deduplication"
  homepage "https://plakar.io"
  url "https://ghfast.top/https://github.com/PlakarKorp/plakar/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "3a654d71873569f06e37ada26baada10912f0d7f478738080e2291bf610fc650"
  license "ISC"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d811dffbdcf7eb303847efab1ba34a3dd50e7f10115d54302585dc9753133d18"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b40e4d390fd90bb2cce8fde53703d1ec69c0e19c57af3ec8a7bbaf7c3556872e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "179615b3de50369607a37e56dd7d093e094de1705c3cc3fd5bc8c7b58cf23560"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e18b9f721446e282960a24baedace1fe0fde44ec1fe12f1c6025fe869d8ebd3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "857861785c63dbe9a2d610536990d8671dade3f991e23865c249ceb5408e3ef0"
    sha256 cellar: :any,                 x86_64_linux:  "5e6269b816e2b21a523e3d32b21bd6e2806589903e132f6997133af3d090e33d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/plakar version")

    repo = testpath/"plakar"
    system bin/"plakar", "at", repo, "create", "-plaintext", "-no-compression"
    assert_path_exists repo
    assert_match "Repository", shell_output("#{bin}/plakar at #{repo} info")
  end
end