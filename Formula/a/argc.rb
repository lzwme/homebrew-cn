class Argc < Formula
  desc "Easily create and use cli based on bash script"
  homepage "https:github.comsigodenargc"
  url "https:github.comsigodenargcarchiverefstagsv1.19.0.tar.gz"
  sha256 "1c4b67d3adecdd7d36a01af370db8aec628b113f5181bcd388ded84081c9f889"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1e86d10d302d6a793ce9aff67e358b5be739d7965072607fcc16279824229955"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d72ac99fe30862d45a1d3fe0ade17aedeac36b3f91970d80d983c768838ae1c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46dd22f413f7a7ee55852042c1e99b48356c3d7e9dbfb8217458b5de1041dd33"
    sha256 cellar: :any_skip_relocation, sonoma:         "f0c8e58a234b127500fca8534d99b631a23d47a79897e9b46cbc2c184fd9378d"
    sha256 cellar: :any_skip_relocation, ventura:        "1db03913fe1a91a52b3fbd954aee0d04b815c876564c5bfad7a559053a599755"
    sha256 cellar: :any_skip_relocation, monterey:       "58d3aec0efc74500ce2a17d3cde67c4d28279a92eb7a2ea41cf2ecc501961fad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04b0b3f37e5bb2c826a761ca4186bae19d270ca21b7afeffae457b08046870f1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"argc", "--argc-completions")
  end

  test do
    system bin"argc", "--argc-create", "build"
    assert_predicate testpath"Argcfile.sh", :exist?
    assert_match "build", shell_output("#{bin}argc build")
  end
end