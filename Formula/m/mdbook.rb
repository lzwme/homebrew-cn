class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https:rust-lang.github.iomdBook"
  url "https:github.comrust-langmdBookarchiverefstagsv0.4.45.tar.gz"
  sha256 "bba66446316de17cdaea918b195ee7420bf3259746b196d4a5e0eda4d9612122"
  license "MPL-2.0"
  head "https:github.comrust-langmdBook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f717cdeed4a32914c109279f8c365095278f175fca6e2e3e046dc4e24880410"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c599e38946e59d3cbc794722b7a02307647436b0b32edb06b1df62748ed05bd4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8e021cd40483371d9b60fe86d1009dc070d2c14557e6ce0ca662000f690dfa7a"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb30d25f3bc3d336e2ac4793df26e6f918dfd615d3d2ee9d78577a623d08e492"
    sha256 cellar: :any_skip_relocation, ventura:       "4d311b77e2fef5d565b277a878ffcffae3b057fd24b582856cf94e462e4562cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e0b1c4f2d10080268c6048cad5d37c100fcb1517b8128fcf84e867980094e0c"
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