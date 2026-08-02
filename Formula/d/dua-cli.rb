class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://ghfast.top/https://github.com/Byron/dua-cli/archive/refs/tags/v2.40.1.tar.gz"
  sha256 "ca07ea73ad4ed66cbfd0e2d6b709ce2a90a319459582c807b9936a9bc2be1c18"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5a4bc913db8447ee6347d08bdd9b3edc1170a7b069a9509699eefca0e51a682"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bacbbd89250a97f99c5b8ebebc8fdd5b79be363e7829d55b65581202048ef76a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80d428cfb8b17ef568651095b4ed3ae9ffbc29026d7d48ad30d51d773ad1215f"
    sha256 cellar: :any_skip_relocation, sonoma:        "480b7614a2bb8dcf6f7f0939f68331a5e6cf2250b4b8dae155a128272fd63f52"
    sha256 cellar: :any,                 arm64_linux:   "38aef3f4aca8f97cd07935453c9c72af0c39a5e597c05ae1d7e5104791a9b7a1"
    sha256 cellar: :any,                 x86_64_linux:  "ef0ebd6bd5886245e65c1a707eb1d8c7f7de1a99f5dfe63a20d422c2d1aa3df1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Test that usage is correct for these 2 files.
    (testpath/"empty.txt").write("")
    (testpath/"file.txt").write("01")

    expected = %r{
      \e\[32m\s*0\s*B\e\[39m\ #{testpath}/empty.txt\n
      \e\[32m\s*2\s*B\e\[39m\ #{testpath}/file.txt\n
      \e\[32m\s*2\s*B\e\[39m\ total\n
    }x
    assert_match expected, shell_output("#{bin}/dua -A #{testpath}/*.txt")
  end
end