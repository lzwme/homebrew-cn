class KeepSorted < Formula
  desc "Language-agnostic formatter that sorts selected lines"
  homepage "https://github.com/google/keep-sorted"
  url "https://github.com/google/keep-sorted.git",
      tag:      "v0.7.0",
      revision: "ee5e55fd2841386d1236f3e8153b991a8e366f36"
  license "Apache-2.0"
  head "https://github.com/google/keep-sorted.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f8e5cf855921f83dd5c7b0a096f406f643e18b42f9adcf2d014ac780a05f339"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f8e5cf855921f83dd5c7b0a096f406f643e18b42f9adcf2d014ac780a05f339"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0f8e5cf855921f83dd5c7b0a096f406f643e18b42f9adcf2d014ac780a05f339"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1bea50e26a96c28e9f260405f75e3fdf44e07b6a4522509fa34d9a71af15d10"
    sha256 cellar: :any_skip_relocation, ventura:       "e1bea50e26a96c28e9f260405f75e3fdf44e07b6a4522509fa34d9a71af15d10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1c9bc798ad57c50ac9f3cb21fa515fb1a1838f18ded7d6af76d7440d0cc5d43"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/keep-sorted --version")
    test_file = testpath + "test_input"
    test_file.write <<~EOS
      line will not be touched.
      # keep-sorted start
      line 3
      line 1
      line 2
      # keep-sorted end
      line will also not be touched.
    EOS
    expected = <<~EOS
      line will not be touched.
      # keep-sorted start
      line 1
      line 2
      line 3
      # keep-sorted end
      line will also not be touched.
    EOS

    system bin/"keep-sorted", test_file
    assert_equal expected, test_file.read
  end
end