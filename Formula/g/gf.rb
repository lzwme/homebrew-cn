class Gf < Formula
  desc "App development framework of Golang"
  homepage "https:goframe.org"
  url "https:github.comgogfgfarchiverefstagsv2.5.7.tar.gz"
  sha256 "3f1888518d50120ff8723fb49cfba908bd969c02584979a6d44143d41c99de60"
  license "MIT"
  head "https:github.comgogfgf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b27cff8ab9ee00e0df36dd0262aeb3aa38140d60762f442566e9acb0186a84d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8437f65d999955b018e53184b0c223259f0edc48f49ef1e2da19e66385c837c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96568cf0502e88323f8e65ecfbbe013cc254b8499fdba0c900432a70eaf92cf5"
    sha256 cellar: :any_skip_relocation, sonoma:         "965dec6ea580380a0ec5f58559c72ed68835ff7d0fce0ccffb02f561bd50be7c"
    sha256 cellar: :any_skip_relocation, ventura:        "e385fb2929a07a5fac86603eb9a893799e0c110d650e384ce4d871ceca5c83e9"
    sha256 cellar: :any_skip_relocation, monterey:       "5a5440dc5c6e3727317f322ae9f896e648adf787596d77acc89c319573fca34d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61d4c6d888ac5337863688de0b39b40017f7b284e912f30897514e62ddbe9507"
  end

  depends_on "go" => [:build, :test]

  def install
    cd "cmdgf" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    output = shell_output("#{bin}gf --version 2>&1")
    assert_match "v#{version}\nWelcome to GoFrame!", output
    assert_match "GF Version(go.mod): cannot find go.mod", output

    output = shell_output("#{bin}gf init test 2>&1")
    assert_match "you can now run \"cd test && gf run main.go\" to start your journey, enjoy!", output
  end
end