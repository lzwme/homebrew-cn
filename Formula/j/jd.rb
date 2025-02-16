class Jd < Formula
  desc "JSON diff and patch"
  homepage "https:github.comjosephburnettjd"
  url "https:github.comjosephburnettjdarchiverefstagsv2.1.0.tar.gz"
  sha256 "d1211397b92ca445dc65585ab6352a1977c7db37056a59be0dee0f0e11a7e2df"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa665be4acada35f0a16e2951b80da843cc809258729d5e9528634eb8d690337"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa665be4acada35f0a16e2951b80da843cc809258729d5e9528634eb8d690337"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fa665be4acada35f0a16e2951b80da843cc809258729d5e9528634eb8d690337"
    sha256 cellar: :any_skip_relocation, sonoma:        "d44f1c8c0b466e970822ea3d02039ed23162ddf14ecc3f0663c99b389b9e6ca1"
    sha256 cellar: :any_skip_relocation, ventura:       "d44f1c8c0b466e970822ea3d02039ed23162ddf14ecc3f0663c99b389b9e6ca1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78cc1e16356c3142dff0642f17bc01ca8300cf4d131a8a1a735a943889507a7e"
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