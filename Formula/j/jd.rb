class Jd < Formula
  desc "JSON diff and patch"
  homepage "https:github.comjosephburnettjd"
  url "https:github.comjosephburnettjdarchiverefstagsv2.0.0.tar.gz"
  sha256 "aeffdc9d1d1a1af5c7eedc6522834eeea7a5f20e020cbf6ddf9596e334d0f623"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "931417725efe0fd0d2d296088166d65a5453e714384b8be5b1058302c214ac5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "931417725efe0fd0d2d296088166d65a5453e714384b8be5b1058302c214ac5e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "931417725efe0fd0d2d296088166d65a5453e714384b8be5b1058302c214ac5e"
    sha256 cellar: :any_skip_relocation, sonoma:        "7310270a58dfa34a596d81cfc43691d4a0683f81d6c1147ce1d1de3bc4581b12"
    sha256 cellar: :any_skip_relocation, ventura:       "7310270a58dfa34a596d81cfc43691d4a0683f81d6c1147ce1d1de3bc4581b12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c263fa366c7a7a7370b20fbc36ab59f1dcdfdf808e527084dea81661fdb2de4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath"a.json").write('{"foo":"bar"}')
    (testpath"b.json").write('{"foo":"baz"}')
    (testpath"c.json").write('{"foo":"baz"}')
    expected = <<~EOF
      @ ["foo"]
      - "bar"
      + "baz"
    EOF
    assert_equal expected, shell_output("#{bin}jd a.json b.json", 1)
    assert_empty shell_output("#{bin}jd b.json c.json")
  end
end