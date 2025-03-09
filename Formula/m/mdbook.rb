class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https:rust-lang.github.iomdBook"
  url "https:github.comrust-langmdBookarchiverefstagsv0.4.46.tar.gz"
  sha256 "607df9f18cbd5fcec2a3642d8ebf1376b2884e9263c007155d5d3e48d6641cea"
  license "MPL-2.0"
  head "https:github.comrust-langmdBook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27ab6e71abf4d175b5964f9a5d82050ead9385d53c86a5693bfeaa915feeb1e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc447f7a95e2a840cbb9c99d696851f9feb8609de1829a6a9c14b4f544096ff4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aa5448e2485b6040b323385409448e7518eb38d650ce459a54f15f7661587797"
    sha256 cellar: :any_skip_relocation, sonoma:        "567ca90abbb67f8da2748265ed764a23d020b8f3d71b21e60174ae44527c3bce"
    sha256 cellar: :any_skip_relocation, ventura:       "0a93f7d75184f88ed27f0cc28eee2ea6e92e1a3fdb8bdfea538a5f6e6db6461c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8d94aeae0065ccc2b7d9f92db21a06f8aa561954abdffd5fe5f12e9f8b6b199"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"mdbook", "completions")
  end

  test do
    # simulate user input to mdbook init
    system "sh", "-c", "printf \\n\\n | #{bin}mdbook init"
    system bin"mdbook", "build"
  end
end