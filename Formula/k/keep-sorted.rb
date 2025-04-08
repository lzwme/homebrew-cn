class KeepSorted < Formula
  desc "Language-agnostic formatter that sorts selected lines"
  homepage "https:github.comgooglekeep-sorted"
  url "https:github.comgooglekeep-sorted.git",
      tag:      "v0.6.0",
      revision: "df93c2722b6126556183749880f16a9beb664bb4"
  license "Apache-2.0"
  head "https:github.comgooglekeep-sorted.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a1bc62473d80f7809175c4b234a4802384e1c9c61e76d68d74e63b0547a48ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a1bc62473d80f7809175c4b234a4802384e1c9c61e76d68d74e63b0547a48ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3a1bc62473d80f7809175c4b234a4802384e1c9c61e76d68d74e63b0547a48ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab10e635e641f4b72fc32aa7acb82d0672d509d625efa233205ec825f79428a7"
    sha256 cellar: :any_skip_relocation, ventura:       "ab10e635e641f4b72fc32aa7acb82d0672d509d625efa233205ec825f79428a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1db18645ba138068b86a632c11652ba82715098395af15c8f87529400bdb9634"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}keep-sorted --version")
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