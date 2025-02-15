class Rustywind < Formula
  desc "CLI for organizing Tailwind CSS classes"
  homepage "https:github.comavencerarustywind"
  url "https:github.comavencerarustywindarchiverefstagsv0.23.1.tar.gz"
  sha256 "d7ba13370721df4cc6728ca6b956f9a92ab260de08c03ef445a105a87e382546"
  license "Apache-2.0"
  head "https:github.comavencerarustywind.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e05b9993506c365685c99f7b05d720e88c8ca2327ab1ceb1fcbc081f681667a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a520c723738b1bddc8d486daf4f824a49a3b5b7d6b4e7b89476b86cc02ed176"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "44726d34333e418935756b19684d159ab1bb27db577f9725b88b315588dd4a25"
    sha256 cellar: :any_skip_relocation, sonoma:        "83c06900245ea815e2b9786455420adc6182d3f54de8b48c08570eda701f2bed"
    sha256 cellar: :any_skip_relocation, ventura:       "e319851c4b8d0fa6739c868b4d1e40152af226b66fe999cb237898299d057168"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7e803756988646dbed34dbb9bb803e42a65ff504f4c5caf7619b04aaadb0664"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "rustywind-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}rustywind --version")

    (testpath"test.html").write <<~HTML
      <div class="text-center bg-red-500 text-white p-4">
        <p class="text-lg font-bold">Hello, World!<p>
      <div>
    HTML

    system bin"rustywind", "--write", "test.html"

    expected_content = <<~HTML
      <div class="p-4 text-center text-white bg-red-500">
        <p class="text-lg font-bold">Hello, World!<p>
      <div>
    HTML

    assert_equal expected_content, (testpath"test.html").read
  end
end