class MinijinjaCli < Formula
  desc "Render Jinja2 templates directly from the command-line to stdout"
  homepage "https://docs.rs/minijinja/latest/minijinja/"
  url "https://ghfast.top/https://github.com/mitsuhiko/minijinja/archive/refs/tags/2.16.0.tar.gz"
  sha256 "9fb30f6d1d9fc4045e54101fce0add299c3b1a3d0b66542a3a21a0fb44b11217"
  license "Apache-2.0"
  head "https://github.com/mitsuhiko/minijinja.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "abe766bf893dd6e88b64d53fff9bf52054da658824c1c5dd0eef839a0925ac57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25883b9ae2fac63172a659ac10c9bb6dd21d045ec9ac93d006e9eec0fd128a66"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "962d5a702294af1bcc9f44ae29822e7ac0389b779d2277b48d99f26007322323"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d1d0cd94543604769b599aed6091848edb84f507f2fe273674406f15f22228d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "880aa58c5276241881403e55a4914921006e4340e7a074b3879f3d860329c3f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "850d404bca0ea062363de64753b039f3e933ca809782f4ca5fbda50058ab142d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "minijinja-cli")

    generate_completions_from_executable(bin/"minijinja-cli", "--generate-completion")
  end

  test do
    (testpath/"test.jinja").write <<~EOS
      Hello {{ name }}
    EOS

    assert_equal "Hello Homebrew\n", shell_output("#{bin}/minijinja-cli test.jinja --define name=Homebrew")
  end
end