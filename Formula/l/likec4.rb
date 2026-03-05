class Likec4 < Formula
  desc "Architecture modeling tool with live diagrams from code"
  homepage "https://likec4.dev"
  url "https://registry.npmjs.org/likec4/-/likec4-1.51.0.tgz"
  sha256 "51e22a447e20726ef928e8937aec59425346703fb11306d5034558270d3e2caa"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "927a31865121bc60da9ae9aca34a585813e95926105f618bdca4f3edba7dc367"
    sha256 cellar: :any,                 arm64_sequoia: "ffed4ae8732e36722379c36c10470221a0f2be275f726d57eed30f74d024d493"
    sha256 cellar: :any,                 arm64_sonoma:  "ffed4ae8732e36722379c36c10470221a0f2be275f726d57eed30f74d024d493"
    sha256 cellar: :any,                 sonoma:        "949910cdd0c841b4acafd57015f86e3c1d409b1d0ada9a3d0586603751a9fe9c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "215234b8d03ff68bfcbe0ddfb872455e119c27c3b6ffad547e2157842b73b942"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63b97caba6f76522d1eb51f0cafbc7fdf9c19814302ea50addbd9d27f402bb98"
  end

  depends_on "pnpm" => :build
  depends_on "graphviz"
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    generate_completions_from_executable(bin/"likec4", "completion", shells: [:bash, :zsh])

    deuniversalize_machos if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/likec4 --version")

    (testpath/"test.c4").write <<~C4
      specification {
        element system
        element component
      }
      model {
        sys = system 'Test System' {
          api = component 'API'
          db = component 'Database'
        }
        api -> db 'queries'
      }
      views {
        view index {
          include *
        }
      }
    C4

    system bin/"likec4", "validate", testpath

    system bin/"likec4", "export", "json", "-o", testpath/"output.json", testpath
    json_output = JSON.parse((testpath/"output.json").read)
    assert json_output.key?("views"), "Expected JSON export to contain views"
    assert json_output.key?("elements"), "Expected JSON export to contain elements"

    system bin/"likec4", "gen", "mermaid", "-o", testpath/"output", testpath
    assert_path_exists testpath/"output"
    mermaid_files = Dir[testpath/"output/**/*.mmd"]
    assert mermaid_files.any?, "Expected at least one .mmd file to be generated"
  end
end