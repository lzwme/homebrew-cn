class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://ghfast.top/https://github.com/ast-grep/ast-grep/archive/refs/tags/0.40.1.tar.gz"
  sha256 "1cbf932913cc5352fb6d1f494f8e21280bdaa0967bb0a7d8320cc410852ee22d"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de5e98a44029f9698de7f1c99c934d3d0230aa487bf5845efa4115ad176a6e64"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cac6ab90d7ac240f0584bac568e92a677b5520b27d18657d7c829221d2bad034"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dddaf4bbaa65f5dbaff8a37e38fec98d2215fa482d0232672259e5800020919f"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e178e7d9fb827a74d698cf991571c40fb9e65e34b693f7c88bcd08c2910828c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4138756b594c363d21b2a9b43425e300f463487b7b670fbc1584f5791cb6d31a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3491b286a1c27ac425118b9980379a699c797eac0139d946d068488420fb4ec"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")

    generate_completions_from_executable(bin/"ast-grep", "completions")
  end

  test do
    (testpath/"hi.js").write("console.log('it is me')")
    system bin/"ast-grep", "run", "-l", "js", "-p console.log", (testpath/"hi.js")

    assert_match version.to_s, shell_output("#{bin}/ast-grep --version")
  end
end