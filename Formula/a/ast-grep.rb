class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://ghfast.top/https://github.com/ast-grep/ast-grep/archive/refs/tags/0.39.2.tar.gz"
  sha256 "cc64636f510fef88a4811ec526035d9d124f5506d18840f6c95b7e9a301efdd5"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5287ce1530e8a6dee83ad1cb5649bcb152f21248acf42fb5066c1ea807f677ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cae853d4d9db36a3e3c394d094f8f05bc9ddace62dd250b08a0600c080c40d1b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1dd06b7621b53174081962358a0e29e6b17483e19180ec78a04fda98b2ffacbe"
    sha256 cellar: :any_skip_relocation, sonoma:        "abc42a09cfb3969aed541d526f83ce8a1bbc4d36d144b1967cf154eaf9a67f98"
    sha256 cellar: :any_skip_relocation, ventura:       "63b4bafac7e64ded5d0f4a7a0acf0a5152422fcb14ef278fea7372ec44eb0412"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a14bc7df525c728ff356490b6812e6fc37777ab0060dd2a7a91e198d4013cb75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4c8e6d15c8c5a04f85a10ee362ddc9a7711f4fa5ce0f3884e5437500f5b5ef1"
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