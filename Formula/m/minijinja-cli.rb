class MinijinjaCli < Formula
  desc "Render Jinja2 templates directly from the command-line to stdout"
  homepage "https:docs.rsminijinjalatestminijinja"
  url "https:github.commitsuhikominijinjaarchiverefstags2.8.0.tar.gz"
  sha256 "bdad3b19ffaf09c34eb97b254a05a9184f021003a66d69f01f20a5b6417b8bba"
  license "Apache-2.0"
  head "https:github.commitsuhikominijinja.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c99b6df1403631de360a4213dcc06f9f98c1fc962df20c677a52d36b36c3bb6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d6b0941fd4827d025053c20f83eb63587adc6640ad13bf85daabaedf0a98bc2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7e5bb73998a700359a80cbad2f719fa3d2c970165d8a300beeefce4a05329b47"
    sha256 cellar: :any_skip_relocation, sonoma:        "dcf3a5c2e27c48d587f019e96c444c800ae7feaeb386be83a0fb368061a774e6"
    sha256 cellar: :any_skip_relocation, ventura:       "035a3197b355913e593f8c090ec0aaa697567329c0ba07464b711148ed036a27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8030eca391b847be67a8926b8822d63a5bdc5ab9ebba9d8226ed6ff0374aa860"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f11e6ea1268b5fb01c00034d190c2ccbac413f0fdc69977a200efa2f8c922f0d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "minijinja-cli")

    generate_completions_from_executable(bin"minijinja-cli", "--generate-completion")
  end

  test do
    (testpath"test.jinja").write <<~EOS
      Hello {{ name }}
    EOS

    assert_equal "Hello Homebrew\n", shell_output("#{bin}minijinja-cli test.jinja --define name=Homebrew")
  end
end