class Likec4 < Formula
  desc "Architecture modeling tool with live diagrams from code"
  homepage "https://likec4.dev"
  url "https://registry.npmjs.org/likec4/-/likec4-1.57.0.tgz"
  sha256 "02abb661ed6f955d4ef210b05d980935faa07cb39803812e10f07fa712ead48d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "53457d39f2645be8bae9d25baa1b9e87b3cb88b37f71a74af723a653928d101b"
    sha256 cellar: :any,                 arm64_sequoia: "e4c2405e7a6c918b23ee1a5eff2bf9ef7daf1a47005a60aaffd397c95702641b"
    sha256 cellar: :any,                 arm64_sonoma:  "e4c2405e7a6c918b23ee1a5eff2bf9ef7daf1a47005a60aaffd397c95702641b"
    sha256 cellar: :any,                 sonoma:        "f3db651ecd442814fc1119de6fd9b4341399c1b706a954f580f79bcfca3b5bef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75dccb2bc40e6e481d16b0ad77296601dbea89a4687e354e99956ccc43eb10fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98bd4a284752b29027b1a80c49f6711167c835e8a40c226d8a995f16d3a43461"
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