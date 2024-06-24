class Oj < Formula
  desc "JSON parser and visualization tool"
  homepage "https:github.comohler55ojg"
  url "https:github.comohler55ojgarchiverefstagsv1.22.1.tar.gz"
  sha256 "bf457a7e35806a63f7ac3ff09f453c663186ab53f8b67515e0890cbcf44da771"
  license "MIT"
  head "https:github.comohler55ojg.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5fb52aa018e3a0d5ecdf80342be28012cd46e266aa6dd2992d38b346ea1c70ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5fb52aa018e3a0d5ecdf80342be28012cd46e266aa6dd2992d38b346ea1c70ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5fb52aa018e3a0d5ecdf80342be28012cd46e266aa6dd2992d38b346ea1c70ca"
    sha256 cellar: :any_skip_relocation, sonoma:         "a674a97d63edf8e80ca91c9972f17e81ebc058f1033273308963918ab65d9d24"
    sha256 cellar: :any_skip_relocation, ventura:        "a674a97d63edf8e80ca91c9972f17e81ebc058f1033273308963918ab65d9d24"
    sha256 cellar: :any_skip_relocation, monterey:       "a674a97d63edf8e80ca91c9972f17e81ebc058f1033273308963918ab65d9d24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1b9ecfb9ddbdd3475d5ced246bbd184cdee1011e25f8671af3ef813438f8262"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}"), ".cmdoj"
  end

  test do
    assert_equal "1\n", pipe_output("#{bin}oj -z @.x", "{x:1,y:2}")
  end
end