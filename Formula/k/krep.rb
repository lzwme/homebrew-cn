class Krep < Formula
  desc "High-Performance String Search Utility"
  homepage "https://github.com/davidesantangelo/krep"
  url "https://ghfast.top/https://github.com/davidesantangelo/krep/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "cfe921da29aaf3877531837ee5fac244555f619da9ebc948fa135790dfe647fd"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42328c1fb3e47dca5cd25275bce384c334364cd233d8e9badd8d0098de4742a2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e40d459c63507a6244fbc637d4fb248a84db7bb721bcf97c73e3c636c85c596"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a159c58faf1f7df1022eeb4672163144c33383cf6007b441873dc06fc224c783"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa4153b3fa26b92c364cd565cc4cf8edde3b3eee00187cb1a7b0339aabd159a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae591caafb9d6dcfd7d3de9edebb103f012711e81a0e73c6d68121485079a600"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fcf30adf67790d1b4d1267fffc66ae2de2a6f050f7e58cc42afc7c5d5e09084"
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