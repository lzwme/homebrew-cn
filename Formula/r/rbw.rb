class Rbw < Formula
  desc "Unofficial Bitwarden CLI client"
  homepage "https:github.comdoyrbw"
  url "https:github.comdoyrbwarchiverefstags1.13.1.tar.gz"
  sha256 "2e3181417732b5ab32456a1babff2febeee695604e85db2c94668270ed8a2036"
  license "MIT"
  head "https:github.comdoyrbw.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1a7648d23731fb9e8f05674189f7e3a8e909090dd79b19e429e03edd836cfec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1b24beb9d250f655dc671149564b2c68ad39ad075ee713ceb37a0f1ac223f49"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "eae28b7a7cab047a628b9341c5cf8f12ca9cf1838374987f5ec5a4b71af33ef1"
    sha256 cellar: :any_skip_relocation, sonoma:        "188b0f9b49a7fa6e51dc30cdf8d6bed0b4c8f51410b97ff5760c8b9868b84cb7"
    sha256 cellar: :any_skip_relocation, ventura:       "be92a52bc7eb0b091fa3ae6613d09b25691369e22a408117f3617e766aab504d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dede1de19d15948c2719724a7604fb8c6c92c60eda839fbcafd861ff917ff7f2"
  end

  depends_on "rust" => :build
  depends_on "pinentry"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"rbw", "gen-completions")
  end

  test do
    expected = "ERROR: Before using rbw"
    output = shell_output("#{bin}rbw ls 2>&1 > devnull", 1).each_line.first.strip
    assert_match expected, output
  end
end