class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https:murex.rocks"
  url "https:github.comlmorgmurexarchiverefstagsv5.3.6000.tar.gz"
  sha256 "ecebd385bea7fe2fe8a9cf918d50874c3436b19f7035fb2347243abbcb4656e7"
  license "GPL-2.0-only"
  head "https:github.comlmorgmurex.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c6570431fe5c9db3cf5ee2a725fc435e2deb073f31145d56dd63f6814903c6cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "50198e4c3befae8cf58d906be6c0624892aad591ac269ebed7e84a2b03f1824c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43e391bc261a659476daef58fd34df8984286ba1c1333fceb7b4c7288973e520"
    sha256 cellar: :any_skip_relocation, sonoma:         "10b905b130f204b4b6314d794be71506c109b8f6180d8f77aada4b5baa841617"
    sha256 cellar: :any_skip_relocation, ventura:        "094532d969f7f579e73a69f11162890918b9f18524a6f00b24764feee10f144b"
    sha256 cellar: :any_skip_relocation, monterey:       "88ae68575d47d176b4a108e42ed750f9f903d08b42217e35848899649de9b8a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a83aca0c3abaff0a1a3a30ff5033163194f381c05e371264b6a8dce7bf4ebafb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_equal "homebrew", shell_output("#{bin}murex -c 'echo homebrew'").chomp
    assert_match version.to_s, shell_output("#{bin}murex -version")
  end
end