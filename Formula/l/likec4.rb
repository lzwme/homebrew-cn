class Likec4 < Formula
  desc "Architecture modeling tool with live diagrams from code"
  homepage "https://likec4.dev"
  url "https://registry.npmjs.org/likec4/-/likec4-1.59.4.tgz"
  sha256 "269bcb446e4155fa82c1cca20afd44905ddf88a7737c17431d4636c251cb1d6b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "6b64ce8b94aa063f3a0ce62ecef805cc9be8f7b01b8a462813d7bd704bdf2119"
    sha256 cellar: :any,                 arm64_tahoe:       "6b64ce8b94aa063f3a0ce62ecef805cc9be8f7b01b8a462813d7bd704bdf2119"
    sha256 cellar: :any,                 arm64_sequoia:     "6b64ce8b94aa063f3a0ce62ecef805cc9be8f7b01b8a462813d7bd704bdf2119"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9d5f82e3a63966c17b436dacc97b5d39c5f45c8bc45d2ed2b7bc77648cab68c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "1df25da5ac13c90bad80f271455f5defac39609d4126ab6a6995411fabd89200"
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