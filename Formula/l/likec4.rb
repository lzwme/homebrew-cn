class Likec4 < Formula
  desc "Architecture modeling tool with live diagrams from code"
  homepage "https://likec4.dev"
  url "https://registry.npmjs.org/likec4/-/likec4-1.59.0.tgz"
  sha256 "407d3f620813c0dc4ff9efc2c2c8caf5e7b0b93f5a056ee3ba9da645b1945926"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ac36d1bb68c9efed3f0629b927a15b9a4401ab2a875e7b9cf83325c4878fedbf"
    sha256 cellar: :any,                 arm64_sequoia: "ac36d1bb68c9efed3f0629b927a15b9a4401ab2a875e7b9cf83325c4878fedbf"
    sha256 cellar: :any,                 arm64_sonoma:  "ac36d1bb68c9efed3f0629b927a15b9a4401ab2a875e7b9cf83325c4878fedbf"
    sha256 cellar: :any,                 sonoma:        "d51b5855afd6be8495d52b229bd804675794c265f12772d560f04e8f6f6ca7a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ff3c9faecc7c9c5cd68a5f3ec5cfe6d8ad3dcd93cffc017d6bf5f20fe7a36bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "160bcf3a560c438a1a740c268f8927b6d364ebb68d232309a288e8daef549334"
  end

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