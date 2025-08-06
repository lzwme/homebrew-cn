class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://ghfast.top/https://github.com/ast-grep/ast-grep/archive/refs/tags/0.39.3.tar.gz"
  sha256 "4436a300e97031f46f0cf37101b5422a9e6b74062678a9bffde13ed88f1145c2"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e6e5c6c568aae0eb1a55e76277600c7764567455a28b1a80a3212b9c33a938a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7f4eaf11f83c915e4016677cc50e7ccdda5f1199db19e1657bedb3fcdfe8922"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f585792ae5b0e48c404c2e9090ca2a7d9b78af0b90b58e6bad9ab3ac00686341"
    sha256 cellar: :any_skip_relocation, sonoma:        "00e2679d6afa2064754d108be0fa3eebb62b2abc747ea9f7514276898db7e6c4"
    sha256 cellar: :any_skip_relocation, ventura:       "f5380027202657dba6eaa720675fb4e3be4350a5899c6119246d922815283fd8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0def31c303c7deeee3a79987913b824529448f3d8d8f162948531d3ac1673c5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e67975caaf6dab17060b6c7442ba6342b6c2005e96806a522b992c213cbf9738"
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