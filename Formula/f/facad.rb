class Facad < Formula
  desc "Modern, colorful directory listing tool for the command-line"
  homepage "https:github.comyellow-footed-honeyguidefacad"
  url "https:github.comyellow-footed-honeyguidefacadarchiverefstagsv1.4.0.tar.gz"
  sha256 "466569e116fd31ff03ee18b3b581d74735ea447f481ba88bdd8c037c8ad85365"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff14bbb65978cf2ce48a2a49b8ae16748402e59c51dfd679029a91f8ee2b5e34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e646eec1669105d667d3730c53f9d88912d30dfaec11e710b447899d1f0000e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1c75d440cf95ed681ed31d19a42e6c2e554e69fcc5063eaa13822f8a74d8918d"
    sha256 cellar: :any_skip_relocation, sonoma:        "63205c07eb2bebadcbbdb48acb657bce23b51327cdbc23ccb11d24b491ac3ae9"
    sha256 cellar: :any_skip_relocation, ventura:       "03991ac6158ce90c59ab43ecfe088b8ba2600957930fd669cb38b4add448a499"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc0b356f2d9d9f46103c022a14f4ab5610722574d50cb26b95425004ef17fd66"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match "facad version #{version}", shell_output("#{bin}facad --version")

    Dir.mkdir("foobar")
    assert_match "📁 foobar", shell_output(bin"facad")
  end
end