class Sprocket < Formula
  desc "Bioinformatics workflow engine built on the Workflow Description Language (WDL)"
  homepage "https://sprocket.bio"
  # pull from git tag to get submodules
  url "https://github.com/stjude-rust-labs/sprocket.git",
      tag:      "v0.21.1",
      revision: "16a97e58197031d3c07112192f23efceb7f036de"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/stjude-rust-labs/sprocket.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d056b430fcaf6f9b60fc8b2525931d2b4d1bb2fa71b6faba371b5254a99d6233"
    sha256 cellar: :any,                 arm64_sequoia: "08d4bb62e1ba6ff747cba6c1022cf1284f51ee144ab9e158b6d87e4986ff0fe1"
    sha256 cellar: :any,                 arm64_sonoma:  "67ff5fb72318fbc590f0a079e6f0ddde07e4d57288c0ece99284c4819b89b2ab"
    sha256 cellar: :any,                 sonoma:        "c11de257a93fa6555cc5bd1e48017c5b56f34633b3796c6442d3b8cc1d6e058e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "497e2a03569ce2a5656d8a444a71462717eccc079f007266ce10f407395123b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f02d5c72c67accddc99639905f3eda3649f6c4cce3ac5f926dee20d2f3b0e50"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
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