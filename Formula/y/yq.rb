class Yq < Formula
  desc "Process YAML, JSON, XML, CSV and properties documents from the CLI"
  homepage "https:github.commikefarahyq"
  url "https:github.commikefarahyqarchiverefstagsv4.45.3.tar.gz"
  sha256 "e3edb61a80691d05f4e6286cf68b0f9e8eba120f1f7326b80b9e17fbed25d49e"
  license "MIT"
  head "https:github.commikefarahyq.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dabd1626fecd45c80f3f29da1d032f765504a506fdd8c4cf7f8568f35456a118"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dabd1626fecd45c80f3f29da1d032f765504a506fdd8c4cf7f8568f35456a118"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dabd1626fecd45c80f3f29da1d032f765504a506fdd8c4cf7f8568f35456a118"
    sha256 cellar: :any_skip_relocation, sonoma:        "939b648fc9e66e7a497e92d59cd2d5881a0a1fb42cc7fdbd8bc83f9fd0f8ffab"
    sha256 cellar: :any_skip_relocation, ventura:       "939b648fc9e66e7a497e92d59cd2d5881a0a1fb42cc7fdbd8bc83f9fd0f8ffab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e78daaead01cc0c2417183df2942129f2e9ce864dcf55611592b8b0230540cb9"
  end

  depends_on "go" => :build
  depends_on "pandoc" => :build

  conflicts_with "python-yq", because: "both install `yq` executables"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    # Install shell completions
    generate_completions_from_executable(bin"yq", "shell-completion")

    # Install man pages
    system ".scriptsgenerate-man-page-md.sh"
    system ".scriptsgenerate-man-page.sh"
    man1.install "yq.1"
  end

  test do
    assert_equal "key: cat", shell_output("#{bin}yq eval --null-input --no-colors '.key = \"cat\"'").chomp
    assert_equal "cat", pipe_output("#{bin}yq eval \".key\" -", "key: cat", 0).chomp
  end
end