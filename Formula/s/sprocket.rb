class Sprocket < Formula
  desc "Bioinformatics workflow engine built on the Workflow Description Language (WDL)"
  homepage "https://sprocket.bio"
  url "https://ghfast.top/https://github.com/stjude-rust-labs/sprocket/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "faeb5b7b73bc3b86e3357f80704bee26ada3d92890d365588a607c5ab65ddbf5"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/stjude-rust-labs/sprocket.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2f6b050064aa11ccd034550c7fd0711a4e685a5e024d1971032039d5662de86c"
    sha256 cellar: :any,                 arm64_sonoma:  "0f10784df18856abb7570b80300a7fd1161adc36cecf7f3bcc19a0dfcb832bc2"
    sha256 cellar: :any,                 arm64_ventura: "fce21b0d0ccf6d895a6c922ba5297b5a437d2b038ef962dc81b362b33a4f3ce4"
    sha256 cellar: :any,                 sonoma:        "42c17ed5a2af26635998247e02ed10efdb58775c0571b178cf366b7e67a34a7a"
    sha256 cellar: :any,                 ventura:       "52ea234378ba092d5aa83c0dd364e988366a1bb5706cf3af1b933d3b6466463d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbcfae73d86a81d0b0e20920af9a3e2c25467d0df50e25fe4f363f7d9e014d08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db5c849162d8e0825b8de18ea9bb7e0b7371c0dfb1745c34e4bbe6c9445d6e9a"
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