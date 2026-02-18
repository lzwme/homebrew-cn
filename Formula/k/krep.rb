class Krep < Formula
  desc "High-Performance String Search Utility"
  homepage "https://github.com/davidesantangelo/krep"
  url "https://ghfast.top/https://github.com/davidesantangelo/krep/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "acc94b941f3b046077803adc300c8eccbe813955f772dbf8b1f6a8fc2921f24b"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c02dad3d3f7cd2d7c0e8f6a6a9dd653092229ca055f3014d09278f69947200cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a903b0728848f6dd2f02ba2031d090247e8dd1a359afdec2148ff44f4ab50337"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "46c941e47fb42fa6e6bba2595f2758ccbe7457da0c958d304e1798682ee3caa8"
    sha256 cellar: :any_skip_relocation, sonoma:        "09f001ca1c0cfecc078adc6c039d04f49318ed7a27aba53a1af186158055b465"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d8967d3bdd77b01e174efb343a1c8f37129adee549d99dcea9229d8b4f8dc14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4a280a14bbda27458fd0db4b1567eabf2431047d452a712204b4f6b1bde06f1"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.major_minor.to_s, shell_output("#{bin}/krep -v")

    text_file = testpath/"file.txt"
    text_file.write "This should result in one match"

    output = shell_output("#{bin}/krep -c 'match' #{text_file}").strip
    assert_match "1", output
  end
end