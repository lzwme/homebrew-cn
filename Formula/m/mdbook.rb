class Mdbook < Formula
  desc "Create modern online books from Markdown files"
  homepage "https:rust-lang.github.iomdBook"
  url "https:github.comrust-langmdBookarchiverefstagsv0.4.41.tar.gz"
  sha256 "9a38dbb6c28d5d58c34644074e113b0b80cea89e39bba70a126ee69a2e5f477c"
  license "MPL-2.0"
  head "https:github.comrust-langmdBook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d40690b0930022da1e51d47ccaffa45e81489d9901d3f14a38e03633cb11ef3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae9674ac4cf2aa94b596a7ed8bee6ec15f1ee07203c3ef9252fd716289f1447a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e68d5854802c8c7a26a3154cd3ed844e40167d5ed1ad053c390c75ad12b40d92"
    sha256 cellar: :any_skip_relocation, sonoma:        "a721e90f3c4a4ec3ad64be333becbe93e88f97350ff05b5636c55661c72e4f4d"
    sha256 cellar: :any_skip_relocation, ventura:       "e2375e1d82400c13285326418427c8da807365a028681bbc2dcef04fdf192609"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fecaf3da5fccb410185dafe00dfaeba127a318cc182765b500da9ff1ba60cc91"
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