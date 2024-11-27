class Goread < Formula
  desc "RSSAtom feeds in the terminal"
  homepage "https:github.comTypicalAMgoread"
  url "https:github.comTypicalAMgoreadarchiverefstagsv1.7.1.tar.gz"
  sha256 "29e15a110ad1844adf6990033d118df4ec3ff6ccbe68b36eb6729867db8ec375"
  license "GPL-3.0-or-later"
  head "https:github.comTypicalAMgoread.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "370e06cee7a0e012e29192aad1510c13148c516d5518f04ece53d45c894977f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "370e06cee7a0e012e29192aad1510c13148c516d5518f04ece53d45c894977f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "370e06cee7a0e012e29192aad1510c13148c516d5518f04ece53d45c894977f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "62fddcb4abfa9ca7c7e1b246e1a6c4d8f36160adc4c1f351a7f41b7500ce6eb5"
    sha256 cellar: :any_skip_relocation, ventura:       "62fddcb4abfa9ca7c7e1b246e1a6c4d8f36160adc4c1f351a7f41b7500ce6eb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50aada6c4ed52d0d7385b0e3667b1981af8338df896c00dbf81fd40e2aca8107"
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