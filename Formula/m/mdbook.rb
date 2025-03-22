class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https:rust-lang.github.iomdBook"
  url "https:github.comrust-langmdBookarchiverefstagsv0.4.47.tar.gz"
  sha256 "846a59ca86bcd014322267995ba307cd6a197081f4b75d085596d723dd8a633e"
  license "MPL-2.0"
  head "https:github.comrust-langmdBook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7a8078e92d22083dc01c60a7795f23fb434c7aae602abec6ce6960d7b923745"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "627b556a28e60313fac1634fdb67019dd462d9c872376618e413d06661923f8f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "85613c76861271f3cc2e02be9ee186ecc7832df5712307f9251ab8f2c7186610"
    sha256 cellar: :any_skip_relocation, sonoma:        "07d9e4d871d00f14987b7fa137cf2eac1f8e063395d84969734287bb8f79a48c"
    sha256 cellar: :any_skip_relocation, ventura:       "6494a9e97b7322dc8945c9fcbbde3c01178055afd9015117edbee6733c94d7fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9fa6fb5021e8a4b9befc14fbddcc69007dbce83347b44cf1b24218fc3036ca4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "681ccedde8f79819fee2cd1a409f21b9b0251e944689ea5ee4e1ea9509126962"
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