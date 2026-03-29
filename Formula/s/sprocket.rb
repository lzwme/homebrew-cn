class Sprocket < Formula
  desc "Bioinformatics workflow engine built on the Workflow Description Language (WDL)"
  homepage "https://sprocket.bio"
  # pull from git tag to get submodules
  url "https://github.com/stjude-rust-labs/sprocket.git",
      tag:      "v0.22.0",
      revision: "d022d74d39cb8c3e537d99e0dd4980c75a2e6a99"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/stjude-rust-labs/sprocket.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "7b5b4674bbe74baa303745ad30a16e1eee09815a12681cccdd9f4014c47f0425"
    sha256 cellar: :any,                 arm64_sequoia: "f20bfae256ab5db082cf63116a3ce167a481929214ee14c2941809b94c25e719"
    sha256 cellar: :any,                 arm64_sonoma:  "11a6c1c241bc44c190e219eb4771618c48f3afb03394b91a8735e2093029d11d"
    sha256 cellar: :any,                 sonoma:        "f5b8f7374e2036af18819d3004e821dc1eaab8aba47476062fa1c843890742f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "964c7b25ea8981adda2037f79197937dbcd67b8f8137fbcdaa68f1507ded08cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab377ecabb1e59c3ce4993a558bd4f2c2f08f286fe4d282fdb224fd3c89ce07c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

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

    expected = <<~JSON.strip
      {
        "say_hello.greeting": "String <REQUIRED>",
        "say_hello.name": "String <REQUIRED>"
      }
    JSON

    assert_match expected, shell_output("#{bin}/sprocket inputs --name say_hello #{testpath}/hello.wdl")
  end
end