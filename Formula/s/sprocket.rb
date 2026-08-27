class Sprocket < Formula
  desc "Bioinformatics workflow engine built on the Workflow Description Language (WDL)"
  homepage "https://sprocket.bio"
  url "https://ghfast.top/https://github.com/stjude-rust-labs/sprocket/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "ba465be9049007a31daa7d70369b3f82a086bf262e11bd62979da0137fb00950"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/stjude-rust-labs/sprocket.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4ad84b43d6aa40e7826dfc8f2e2eb81bdc99081c6fd5539c870d5adf24960c77"
    sha256 cellar: :any, arm64_sequoia: "84ccbf8ad9991b5627bbb4f109d174f9a770f4b5359af06de0c0f269f626859f"
    sha256 cellar: :any, arm64_sonoma:  "6833e06b599af560e59c9a8f4717fcb2b2b784ffe3f3ff865f203ee518a3b0de"
    sha256 cellar: :any, sonoma:        "096433c64ca81c1459aadf19ae9d215198230233d24f81df6fc59b7a4a133dcd"
    sha256 cellar: :any, arm64_linux:   "592ac95da37b6edc0959ae63ea59f3d924af801af4c4d3633f1c02bb1ec254de"
    sha256 cellar: :any, x86_64_linux:  "e6e9bb532ab19be82e503d644ac4bb30375dc9d0fdbabd766f7a5b339056b394"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"sprocket", "completions", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sprocket --version")

    (testpath/"hello.wdl").write <<~WDL
      version 1.2

      task say_hello {
        input {
          String greeting
          String name
        }

        command <<<
          echo "~{greeting}, ~{name}!"
        >>>

        output {
          String message = read_string(stdout())
        }

        runtime {
          container: "ubuntu:latest"
        }
      }
    WDL

    output = shell_output("#{bin}/sprocket inputs --target say_hello #{testpath}/hello.wdl")
    assert_match <<~JSON.strip, output
      {
        "say_hello.greeting": "String <REQUIRED>",
        "say_hello.name": "String <REQUIRED>"
      }
    JSON
  end
end