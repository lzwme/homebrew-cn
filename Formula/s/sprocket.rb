class Sprocket < Formula
  desc "Bioinformatics workflow engine built on the Workflow Description Language (WDL)"
  homepage "https://sprocket.bio"
  url "https://ghfast.top/https://github.com/stjude-rust-labs/sprocket/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "bb8364ae4d323d2ab1c3de60aa479fce2e6c922f7500e1462ca85671fc856433"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/stjude-rust-labs/sprocket.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4a8019db8b73c7e9c54438cfaa0ca7f33d6c2b982ad68f602fc6e4c951bbfb84"
    sha256 cellar: :any,                 arm64_sonoma:  "8f3c2d00dd33710838da51ebb4705b0bff1ee5807757a6cc837fa14f56ba2c75"
    sha256 cellar: :any,                 arm64_ventura: "90974677931267583f965dd5a7b2f772c8bbef398c619f45cb816152434f91eb"
    sha256 cellar: :any,                 sonoma:        "3caf0f88b2abae6ab506527a7d9b520dd853a128e0810db7676854decaeb4878"
    sha256 cellar: :any,                 ventura:       "aaa8fbb13dc34176c80acb78ec4b0e106ce211b1349236fb9b2d91774405bb29"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9b7d6624a47fb8045126b5c978949dab8fec1de28136c327e8fcb8b1df7f3ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0bf77fdc5153e3d1505fc267da7a686687323d77f384647fff55708f2c4152d9"
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