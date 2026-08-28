class Sprocket < Formula
  desc "Bioinformatics workflow engine built on the Workflow Description Language (WDL)"
  homepage "https://sprocket.bio"
  url "https://ghfast.top/https://github.com/stjude-rust-labs/sprocket/archive/refs/tags/v0.30.1.tar.gz"
  sha256 "f0c425502ef2330cd90f386012b20d2c5e6bcc4e80ae89ee1c5d419bee3c2fbf"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/stjude-rust-labs/sprocket.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bbb9c68f649c64c6f47e9c9c88c766b0455982d7fd0834968e3c7eaebbd14edc"
    sha256 cellar: :any, arm64_sequoia: "8daf37530f9fd357b528a9d1c048b8b0e7e8c3c3510cc4f8342b691d41ad66e2"
    sha256 cellar: :any, arm64_sonoma:  "78b92a09932ee4734960ba41ee65011936b8bc2a7d5e22cb9462b14135f56afc"
    sha256 cellar: :any, arm64_linux:   "00b316bdd51c9da5aaf60f519ed90a04b7d874a1677f43d5e47c10a971851083"
    sha256 cellar: :any, x86_64_linux:  "3192560b2f257f319d94174d89e96b0a12777a489949fcf4231f9c66c7ad8ee3"
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