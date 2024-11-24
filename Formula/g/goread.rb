class Goread < Formula
  desc "RSSAtom feeds in the terminal"
  homepage "https:github.comTypicalAMgoread"
  url "https:github.comTypicalAMgoreadarchiverefstagsv1.7.0.tar.gz"
  sha256 "bf7b8cb47f9ea78bb445fc2679df6a383cb4e0133b000e4bbee1dee660f71a26"
  license "GPL-3.0-or-later"
  head "https:github.comTypicalAMgoread.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc4e7fabecb4dbeec0469872a1b7537861082bce8e0548a3f175b0bcc764be2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc4e7fabecb4dbeec0469872a1b7537861082bce8e0548a3f175b0bcc764be2b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fc4e7fabecb4dbeec0469872a1b7537861082bce8e0548a3f175b0bcc764be2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "74263d896796e6887948950eadf7cdd48e4aa3fde57b24846e19ac95bd1f2092"
    sha256 cellar: :any_skip_relocation, ventura:       "74263d896796e6887948950eadf7cdd48e4aa3fde57b24846e19ac95bd1f2092"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0888998680667c174eb0d11fb93e4a9a2fe26baab478a28fb76dc2b6c2d9150e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}goread --test_colors")
    assert_match "A table of all the colors", output

    assert_match version.to_s, shell_output("#{bin}goread --version")
  end
end