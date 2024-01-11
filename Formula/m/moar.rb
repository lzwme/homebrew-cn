class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https:github.comwallesmoar"
  url "https:github.comwallesmoararchiverefstagsv1.22.1.tar.gz"
  sha256 "a35f00173ca56a8468082b917e742151fbeaeaeb4e86441879eec61076025f81"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f832d67f0effd14db7f613d9d1a1cd69479287c9df47b86c824b36ec35049d60"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f832d67f0effd14db7f613d9d1a1cd69479287c9df47b86c824b36ec35049d60"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f832d67f0effd14db7f613d9d1a1cd69479287c9df47b86c824b36ec35049d60"
    sha256 cellar: :any_skip_relocation, sonoma:         "0f1f8eba0fd433abc90056eb2ed04249fb32e9575085ae8e7a8e41c553f45abf"
    sha256 cellar: :any_skip_relocation, ventura:        "0f1f8eba0fd433abc90056eb2ed04249fb32e9575085ae8e7a8e41c553f45abf"
    sha256 cellar: :any_skip_relocation, monterey:       "0f1f8eba0fd433abc90056eb2ed04249fb32e9575085ae8e7a8e41c553f45abf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9078d683410d5abb2e5d6ddcbdd6bc125ac84636cff317071ed8eb58064a65d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
    man1.install "moar.1"
  end

  test do
    # Test piping text through moar
    (testpath"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}moar test.txt").strip
  end
end