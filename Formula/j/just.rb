class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://ghfast.top/https://github.com/casey/just/archive/refs/tags/1.44.0.tar.gz"
  sha256 "450ab569b76053ec34c2ae0616cdf50114a4dce0c2e8dfba2d79bdfb60081a04"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa9134215e42416dcd344c4f659675f05367dc9ea1ae79db2abb06c2437f1421"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "574b11271fec6fb4e6342aa88926cfea65799d033fb592232c7de6018f6ea8ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2c879bcf0164cf160f7b67bfd6250364d09030b6e230193364531ccb32bde9a"
    sha256 cellar: :any_skip_relocation, sonoma:        "8291965413ec005d38b67938a7db045ca4bee174a48ccc9157ca9e6516df3cc8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4093ba474dd131264133308dc24b42d29850690d36d98784868cd1babfe5b6a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ef63b2f347c2d2fd57aa641cc7b874d63780fbcd51615a4bccf29962f242aee"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"just", "--completions")
    (man1/"just.1").write Utils.safe_popen_read(bin/"just", "--man")
  end

  test do
    (testpath/"justfile").write <<~EOS
      default:
        touch it-worked
    EOS
    system bin/"just"
    assert_path_exists testpath/"it-worked"

    assert_match version.to_s, shell_output("#{bin}/just --version")
  end
end