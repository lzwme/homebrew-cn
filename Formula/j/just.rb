class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://just.systems"
  url "https://ghfast.top/https://github.com/casey/just/archive/refs/tags/1.55.0.tar.gz"
  sha256 "5e71c72193f027a60dc8fc1399d4d7cbc5763770d17370835a5e02cca554d80f"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0676eaa03da20d091ca14630db1b8a43b70cae1eadaf746d791f1a68a85d7e3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec7a44b9c94bfcf1bd19fab6911638d4fc18158403371cfc7fd27c3f8bd2376d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb0d4b6d2ec66d7696c83c82353e21b28e8a15fad63f24241db3e3d1416fcca4"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2698dedcabb86a063ad8de744f2425e2a20f3d583cdbc5f741c0ebb04200228"
    sha256 cellar: :any,                 arm64_linux:   "9e8fa5f94e2e0c7911230afddb1538ba6aa689de109468eff97a0166fed5e9e2"
    sha256 cellar: :any,                 x86_64_linux:  "76b493f10bca33fa4501f7d92119abfc28931e5db9151c82f11affb0ab170ce3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"just", "--completions")
    (man1/"just.1").write Utils.safe_popen_read(bin/"just", "--man")
  end

  test do
    (testpath/"justfile").write <<~MAKE
      default:
        touch it-worked
    MAKE
    system bin/"just"
    assert_path_exists testpath/"it-worked"

    assert_match version.to_s, shell_output("#{bin}/just --version")
  end
end