class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https:rust-lang.github.iomdBook"
  url "https:github.comrust-langmdBookarchiverefstagsv0.4.50.tar.gz"
  sha256 "2d86ec7769f4ff3068e86a9bbc46bec4f0b78cffb6021dd24c82a4d44b5d27f6"
  license "MPL-2.0"
  head "https:github.comrust-langmdBook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d129516acbf7cd810946b40d9dc4d9e8004eac27d6fe901942fac4359fe4cfac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b513b194e3733d257d136b01d162d509b063ea39c93b27796169f2fdab98f61"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f6c7d0c3c5ea100fb7aa672bd5691a409bf4ce470a34270964584be1ae8dc3c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "608ebcb2440157e540b400ddd1ebdd018e5ff1db52b0a16af4c38eb69cd6520c"
    sha256 cellar: :any_skip_relocation, ventura:       "2360f5e8c1245ed821a508cab0f38be6aba97b9ca8c3975dc7870215f97961be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36eb82af94fca8df2e02df3d1def3881111221dcef951401f4443fb81aab11bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1d54f1bf86d87a94de8bb7e4922d7c3ad51909389ca496ef700ed68fe675c5ae"
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