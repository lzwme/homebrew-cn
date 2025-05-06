class MinijinjaCli < Formula
  desc "Render Jinja2 templates directly from the command-line to stdout"
  homepage "https:docs.rsminijinjalatestminijinja"
  url "https:github.commitsuhikominijinjaarchiverefstags2.10.1.tar.gz"
  sha256 "63a42a13cfc41f400a3216e036de73cde015e7b9f694e5ae16ea0aea6a1678fa"
  license "Apache-2.0"
  head "https:github.commitsuhikominijinja.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d65984d864a7eb0de9ef897e68edcbe8f32ee3cad590f34e8924ce2210a6a4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6facd289cdf7b9a5dcfd63d38c72a13f6e725fd37b7d2303b338dfd1ca30989f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a4279282041cc7e944d94d8e2ddf5ee623dc7e4bb53659694a7ebb609ac1fef4"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2c7a1c05e9e3208637d7eb3786cf1411b80145799a6a51e08e3ceb95f5c7ef7"
    sha256 cellar: :any_skip_relocation, ventura:       "57c3d82a401835d830cf8e1000a2b94a4d6710066ae60c332aa3e7c4ba22eb60"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b63ba0d8be3c3dcdd6e22a0552875c3a2facb1d572213bf178b44417438e095d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be1756273a668c0b4690937d6c2cd05d1f0e8eccd8df9d0be8d3c10e3e09d99f"
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