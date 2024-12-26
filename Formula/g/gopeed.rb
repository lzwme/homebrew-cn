class Gopeed < Formula
  desc "Modern download manager that supports all platform"
  homepage "https:gopeed.com"
  url "https:github.comGopeedLabgopeedarchiverefstagsv1.6.5.tar.gz"
  sha256 "860bc80131c723789233f0f4491e5097fc160314312584833e777450d2505021"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d435e5398eed633fec96cab041ff510f18c4004eee38d523fdaad43f67ddaecb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9bf6e5c6bfc6ccbeab96c69fc9b6fff9890ae49004b559067095e3ba0eaaf321"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f93e1a9caf5731d786334f9695c0d5b49c725d826332db1e17b53db503d5a71e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1911213a267a985f3714c13489cc166e407b76074da0f1f66a65ded643b13f2"
    sha256 cellar: :any_skip_relocation, ventura:       "b5143d3852b3ac1c0051678a58e6d30af9f04b86085375da45711b3fe5e8db9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "addbc986e51cb2ff04592a81ff11bec4ebb4d423db6e04da8eba133cfe9cbb98"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdgopeed"
  end

  test do
    output = shell_output("#{bin}gopeed https:example.com")
    assert_match "saving path: #{testpath}", output
    assert_match "Example Domain", (testpath"example.com").read
  end
end