class Hk < Formula
  desc "Git hook and pre-commit lint manager"
  homepage "https:hk.jdx.dev"
  url "https:github.comjdxhkarchiverefstagsv0.2.4.tar.gz"
  sha256 "ca726c524c9451628e602686150c8db95c1431b5428ea56284220f00ac7e4cb1"
  license "MIT"
  head "https:github.comjdxhk.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5a8b8bf948306620ef8c59db4c6ec83abd84a336209048edad2da114dac4c7b8"
    sha256 cellar: :any,                 arm64_sonoma:  "f03bd7c664001ee1e0568baedb24f10b7a0ef0d23d919f206842d7a238188457"
    sha256 cellar: :any,                 arm64_ventura: "52c7b3397c5e8d41dbbe8ce941103567cd41ea305aa67d6f21d4880a9b3251ca"
    sha256 cellar: :any,                 sonoma:        "2ed065451c5076c7b406535ceffba428c90904b1ee9d4fed032b0c7a3e575a5e"
    sha256 cellar: :any,                 ventura:       "eb9e126c8c1e8715809c326bb5e58197131e6833b50225cdcaa565f8ba245245"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85eb31f7db7de0711758060fb21632005ab69d397ca3d4375e343b0e10382b24"
  end

  depends_on "rust" => [:build, :test]
  depends_on "usage" => :build
  depends_on "openssl@3"
  depends_on "pkl"

  uses_from_macos "zlib"

  def install
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin"hk", "completion")
  end

  test do
    (testpath"hk.pkl").write <<~PKL
      amends "https:hk.jdx.devv0hk.pkl"
      import "https:hk.jdx.devv0builtinscargo_clippy.pkl"
      import "https:hk.jdx.devv0builtinscargo_fmt.pkl"

      `pre-commit` {
          ["cargo-clippy"] = new cargo_clippy.CargoClippy {}
          ["cargo-fmt"] = new cargo_fmt.CargoFmt {}
      }
    PKL

    system "cargo", "init", "--name=brew"
    system "git", "add", "--all"
    system "git", "commit", "-m", "Initial commit"

    output = shell_output("#{bin}hk run pre-commit --all -v 2>&1")
    assert_match(cargo-fmt\s* ✓ done, output)
  end
end