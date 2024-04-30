class Csview < Formula
  desc "High performance csv viewer for cli"
  homepage "https:github.comwfxrcsview"
  url "https:github.comwfxrcsviewarchiverefstagsv1.3.1.tar.gz"
  sha256 "707d7d6b6960530a1e9476e0c8045da7722d49bff2cd85a42d9debac2eba4d91"
  license any_of: ["MIT", "Apache-2.0"]
  head "https:github.comwfxrcsview.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a8778c6ce71a06e9a9a3b28ee1b515d480f1cca33f244b31211ebd25218f6248"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b9577befd490d1a94a57c510e955aacfeae5b60bc64e5f8595f2b7fc53ff0366"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0f6ac317f3ee31bbdead5d988fefad05f2d41b807d3b2196b0321c861a9e326"
    sha256 cellar: :any_skip_relocation, sonoma:         "fa555d483c1a11cf5c6dcdcde84df51e301cac33c896bf61c35dd010eaa6fba7"
    sha256 cellar: :any_skip_relocation, ventura:        "cc566c3280d1dfc3ab3b1c5c5ece8ed0530fcde3fe6b1060d2913669567730ba"
    sha256 cellar: :any_skip_relocation, monterey:       "89198b9cf79b95aa5f916140d4ddcfde80a79950a2c935cd5bef8fe296356301"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27a06e9ccc3c447519d14cb526bb4c7925c2c8f9dce0f462990502feaf8f82ac"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    zsh_completion.install  "completionszsh_csview"
    bash_completion.install "completionsbashcsview.bash"
    fish_completion.install "completionsfishcsview.fish"
  end

  test do
    (testpath"test.csv").write("a,b,c\n1,2,3")
    assert_equal <<~EOS, shell_output("#{bin}csview #{testpath}test.csv")
      ┌───┬───┬───┐
      │ a │ b │ c │
      ├───┼───┼───┤
      │ 1 │ 2 │ 3 │
      └───┴───┴───┘
    EOS
  end
end