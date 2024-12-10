class Jaq < Formula
  desc "JQ clone focussed on correctness, speed, and simplicity"
  homepage "https:github.com01mf02jaq"
  url "https:github.com01mf02jaqarchiverefstagsv2.0.1.tar.gz"
  sha256 "e554f375500d09813c9a2f4454217b8d12ae3be5dba56bc545b199ae0d4ab72e"
  license "MIT"
  head "https:github.com01mf02jaq.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ccb5805c1ae04b780c347f05215dd5bb7b659c31e9e0f600c8a8948369af25ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "287d3078e5c9a2761b7d83b2bbc2542fc3051aa8f878eb0347dc0d5c82902eb4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bb38aefd1c969476e055b6913f2688e7031e0489569365604b83fb785127105a"
    sha256 cellar: :any_skip_relocation, sonoma:        "82e856c696714d2bf8d18301536a70670526d19bb8056fbf92aa9bd0c56a8555"
    sha256 cellar: :any_skip_relocation, ventura:       "68f4643fb4eea68a22360af9fde9f1c43ca18970fa121261952e63559ff83503"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "91eb2d8a8e5fb8316dfa27db838799cec18aa56b42929ce71c8177eb818a02fe"
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