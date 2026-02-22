class Likec4 < Formula
  desc "Architecture modeling tool with live diagrams from code"
  homepage "https://likec4.dev"
  url "https://registry.npmjs.org/likec4/-/likec4-1.50.0.tgz"
  sha256 "87056aa99e630d50623dc91e1e98b743bf2de06ce4c82ce0423bc4e99e4f090e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ab03cee64ac65a706911eb0709bf0060a0259323b615b2d2b875d61bc4f6dd55"
    sha256 cellar: :any,                 arm64_sequoia: "809baa24925e920e6b8a09a6ac32e43b488a8130523809028aec5d198310fc7c"
    sha256 cellar: :any,                 arm64_sonoma:  "809baa24925e920e6b8a09a6ac32e43b488a8130523809028aec5d198310fc7c"
    sha256 cellar: :any,                 sonoma:        "adafbc2e933fb2f8ca0199f10b2fdcdea623975bb8e9fec181a941807998e2e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7407d3dd1d1a19a8807d033f36a914fef751abf7cae15f66dcf859b43b377152"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20106178de405e96765fcc31f2d7dd4563e96e80e0b769b731da53d90ee3fc39"
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