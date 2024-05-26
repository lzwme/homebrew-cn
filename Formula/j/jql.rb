class Jql < Formula
  desc "JSON query language CLI tool"
  homepage "https:github.comyamafaktoryjql"
  url "https:github.comyamafaktoryjqlarchiverefstagsjql-v7.1.9.tar.gz"
  sha256 "c944b41da99f90718972022be4ba7fc54948b72f1648ac5135b071fb463bb514"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comyamafaktoryjql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d591c3857e12ad319aa9a6c16f8837c743b92b25a0330cac7370f2815fd3b161"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93fb2e7dec722b862b2933901a52d8dd6be5c59e3e3ed7f2446718528d68ce61"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "454cce832eb76cd3f5aff26a6d76fde25bd87f79a263208a2bc438a35e1b4c0c"
    sha256 cellar: :any_skip_relocation, sonoma:         "ff893128107b71b82d31ec8a64cc3d6a0e0b762b6a97b72fa37d76ed6ef7f21e"
    sha256 cellar: :any_skip_relocation, ventura:        "5b668ab9331a614e201bab5b6cc950cbd6931ef2ffe7164d122da623314fa02b"
    sha256 cellar: :any_skip_relocation, monterey:       "552617a464000ada62376ffb5aae6cdb8da413b6657cf334c6b796e90a7eb909"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c3f80301c5a5f45e2739f05a2c0e66c411b022424ce9c806f46e1a1e083b32e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratesjql")
  end

  test do
    (testpath"example.json").write <<~EOS
      {
        "cats": [{ "first": "Pixie" }, { "second": "Kitkat" }, { "third": "Misty" }]
      }
    EOS
    output = shell_output("#{bin}jql --inline --raw-string '\"cats\" [2:1] [0]' example.json")
    assert_equal '{"third":"Misty"}', output.chomp
  end
end