class Codesnap < Formula
  desc "Generates code snapshots in various formats"
  homepage "https:github.comcodesnap-rscodesnap"
  url "https:github.comcodesnap-rscodesnaparchiverefstagsv0.12.8.tar.gz"
  sha256 "e850826ac817a8d60f90aceb65504639edb0b624047690f57e88fde9bb294257"
  license "MIT"
  head "https:github.comcodesnap-rscodesnap.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e23a58c15d4dbc40b28e6027fc8352bad561c8cbbad93d15c92e5787c8e6de5b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "005b1adb479741b5bd0b39264107098d19bba547e1805d5adffa6c4154b4166f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6e337a05ce4d966c9799fd8bd52e51dfdac62e29c84aaef1b4a3316832508e91"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f531d38c2731831b260fb41a60941b3a30ec06fb227a629a7d853ce80bfd2d0"
    sha256 cellar: :any_skip_relocation, ventura:       "ee774c1ae669214b4bb31e372806414234d479f510f4fe561503e1636633cb14"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7456b517fb09d6a6e7ecd619dbe1c962e6ca2524e0abe2019f29b0ea4091083a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "087dba1ec960a55dbdbdbfda15c7159070b5df0bd224a2800174313da9af090d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")

    pkgshare.install "cliexamples"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}codesnap --version")

    # Fails in Linux CI with "no default font found"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "SUCCESS", shell_output("#{bin}codesnap -f #{pkgshare}examplescli.sh -o cli.png")
  end
end