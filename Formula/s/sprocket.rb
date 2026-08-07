class Sprocket < Formula
  desc "Bioinformatics workflow engine built on the Workflow Description Language (WDL)"
  homepage "https://sprocket.bio"
  url "https://ghfast.top/https://github.com/stjude-rust-labs/sprocket/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "e3fc518640fff8b59ee59ebaeef514f1f8d1ff6c6004f54910b5b5541178a94f"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/stjude-rust-labs/sprocket.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "96ab9d866115ab7f86cfa2215e3a7720f38abe339558540947750d5f164cbd41"
    sha256 cellar: :any, arm64_sequoia: "815965cb4d9a2762a2d3d09a7629a2ea5ea22f6b790860678780e10f895ba2aa"
    sha256 cellar: :any, arm64_sonoma:  "545366acf60f76df36e32bb45884f92efc939dc629b4505a6aeccb321ca345f5"
    sha256 cellar: :any, sonoma:        "b455e6d63dea94fd3bf694e05d430eeb7a01324ebc02cf5a060266faaf9cd570"
    sha256 cellar: :any, arm64_linux:   "1dc36a47f71cee98483b9aa53d040c27b4174119a040e2610e7de9ee9b912036"
    sha256 cellar: :any, x86_64_linux:  "7e884be1a1a9fee1868e87e33b18fbb7af39d5e5c2d5d98e9e977fa66548ba96"
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

    output = shell_output("#{bin}/sprocket inputs --target say_hello #{testpath}/hello.wdl")
    assert_match <<~JSON.strip, output
      {
        "say_hello.greeting": "String <REQUIRED>",
        "say_hello.name": "String <REQUIRED>"
      }
    JSON
  end
end