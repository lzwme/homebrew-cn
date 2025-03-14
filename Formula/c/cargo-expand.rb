class CargoExpand < Formula
  desc "Show what Rust code looks like with macros expanded"
  homepage "https:github.comdtolnaycargo-expand"
  url "https:github.comdtolnaycargo-expandarchiverefstags1.0.102.tar.gz"
  sha256 "56a200d98d81430c500af3b246d432c3d143dcca84d4fa810f588efcbc794dab"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comdtolnaycargo-expand.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b6d4be6710c18e6c4bf30e4bfe2eb6a468c6e9434f20ba88712de658530d682"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a35cc63ce34befe811175adc953fa4c9b175670a60914bb231aef8bd2044c22e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "15ba591df7b36c1a21d342d6abc4008d79f104f3c3350c4962d1403f2a9efd82"
    sha256 cellar: :any_skip_relocation, sonoma:        "823024f1dc0dbceb579f8bb5dbbae375dc0f94a35dba07a1d7815a7612fdb697"
    sha256 cellar: :any_skip_relocation, ventura:       "e6f4a08b10f106f22ea0da09435acee007759ac5a04e26ca646911e3da8c1d88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffe4346cea6421c9a8623e87596f415dbe36ad685d70b12199f54e0c85c56cc8"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "default", "stable"
    system "rustup", "set", "profile", "minimal"

    system "cargo", "new", "hello_world", "--lib"
    cd "hello_world" do
      output = shell_output("cargo expand 2>&1")
      assert_match "use std::prelude", output
    end
  end
end