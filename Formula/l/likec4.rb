class Likec4 < Formula
  desc "Architecture modeling tool with live diagrams from code"
  homepage "https://likec4.dev"
  url "https://registry.npmjs.org/likec4/-/likec4-1.55.0.tgz"
  sha256 "c2db0dcb69a334d02dea5c20501823728492004c0c1998c5587456d110fc1938"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2dd00f03fe692ef7c365cc8e09b1b7f33f06c2d8494fe7072757c7c187c4d851"
    sha256 cellar: :any,                 arm64_sequoia: "b370b3ab818e36bf62fd2a2e4ee581bd89b5d98b993c4e6503322d6e57bcb9b1"
    sha256 cellar: :any,                 arm64_sonoma:  "b370b3ab818e36bf62fd2a2e4ee581bd89b5d98b993c4e6503322d6e57bcb9b1"
    sha256 cellar: :any,                 sonoma:        "bd228f21c559b6c6b2bf3e2a5f09493eca9cb23c34ce8dcdc2a8fa573e8f4618"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a38385d9adf6617a168055c23bb7e2c17e147d96cd8dc509860247cb6d19c7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "390dbb81b5e198c698e4b67f36ae0579c302eb82084af2f09a62e4c5b7aa3447"
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