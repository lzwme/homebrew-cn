class KeepSorted < Formula
  desc "Language-agnostic formatter that sorts selected lines"
  homepage "https:github.comgooglekeep-sorted"
  url "https:github.comgooglekeep-sortedarchiverefstagsv0.5.1.tar.gz"
  sha256 "91b2058d4b483573d749eec708da14fd81551eb680b80784d92a14fb89d8d69e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95ea198609e47bee30cc80019a2c70a46eacf15b9626bc7c81818cc4d7e9bcbb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95ea198609e47bee30cc80019a2c70a46eacf15b9626bc7c81818cc4d7e9bcbb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "95ea198609e47bee30cc80019a2c70a46eacf15b9626bc7c81818cc4d7e9bcbb"
    sha256 cellar: :any_skip_relocation, sonoma:        "48cd6f30863e808f7143f0af0013b1a4e7fc96b48044925b1d9008e458823332"
    sha256 cellar: :any_skip_relocation, ventura:       "48cd6f30863e808f7143f0af0013b1a4e7fc96b48044925b1d9008e458823332"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "536e45ff436e49d8604a1aebbd51cd3d4bdafbeb543b05af659d93da601a30a9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
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

    system bin"keep-sorted", test_file
    assert_equal expected, test_file.read
  end
end