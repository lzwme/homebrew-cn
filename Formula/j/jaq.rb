class Jaq < Formula
  desc "JQ clone focussed on correctness, speed, and simplicity"
  homepage "https:github.com01mf02jaq"
  url "https:github.com01mf02jaqarchiverefstagsv1.5.1.tar.gz"
  sha256 "a4052d93f761274036e40fdb27f186ffe9555a93d88fee8e2364b6a677ae6426"
  license "MIT"
  head "https:github.com01mf02jaq.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c6396db845db8f7c07657cf0c52274eca08f5fe2418b9a136b4ba15e3a51ff65"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5da4dab01f26d4917151ac911415c4ecc37f8078007235ab85aa92b70b6aca09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0c9aeafe77de81f81b7e6181d146ac9a272150f69d42bba3f46fbe505f15a5b"
    sha256 cellar: :any_skip_relocation, sonoma:         "2f979a1f3e9cb5794b09ce08ee26edebdfe5387a57b4ad37bd44695a8f71920a"
    sha256 cellar: :any_skip_relocation, ventura:        "bec084492b9edee42e9eb169476cf93acbfe69eeb87417164bf2b167cf374013"
    sha256 cellar: :any_skip_relocation, monterey:       "16edd256b2d9fcdc4ee40d219b3e3d697e3bbc6bfb6fbd1a45eed3f4c99522ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb0556a98ef93490d0aa745e99bb58eb41abebc1ad9dc3d9ab7a7d17511db774"
  end

  depends_on "rust" => :build

  conflicts_with "json2tsv", because: "both install `jaq` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "jaq")
  end

  test do
    assert_match "1", shell_output("echo '{\"a\": 1, \"b\": 2}' | #{bin}jaq '.a'")
    assert_match "2.5", shell_output("echo '1 2 3 4' | #{bin}jaq -s 'add  length'")
  end
end