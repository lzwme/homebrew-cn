class Sprocket < Formula
  desc "Bioinformatics workflow engine built on the Workflow Description Language (WDL)"
  homepage "https://sprocket.bio"
  url "https://ghfast.top/https://github.com/stjude-rust-labs/sprocket/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "b21a4a4667f6fe1c1928234340dec5f7fc3fea8c99af18238b61570ed753a641"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/stjude-rust-labs/sprocket.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "006d9ef5c6cebb620fae73dec90ea5a47b57641e1d2b732805039e251b2fd744"
    sha256 cellar: :any,                 arm64_sonoma:  "1b72b2708d510553cd780bb867fe776fb617055a2a36ccda11581641602ed11c"
    sha256 cellar: :any,                 arm64_ventura: "756d1ebca4466fa92b79c05e3a1f7df6293237af2ddac689333e85e7166353ae"
    sha256 cellar: :any,                 sonoma:        "88d6680736fe3fb7ee81f640f681356e419a842a2c703e140f5eda38bbb07f55"
    sha256 cellar: :any,                 ventura:       "27905e09164f3369ba925a100d91e4dd736bf7a89c5b90a08533430fd60013a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fcf31b0fb006d729a9161fca876091bccf467294be67f0543cac79b1b8f3c754"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64bf417b7872467405e5bea8740633edcf45b3727eba8aff9582c677705a67a1"
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
        "say_hello.greeting": "String",
        "say_hello.name": "String"
      }
    JSON

    assert_match expected, shell_output("#{bin}/sprocket inputs --name say_hello #{testpath}/hello.wdl")
  end
end