class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https:usage.jdx.dev"
  url "https:github.comjdxusagearchiverefstagsv1.3.4.tar.gz"
  sha256 "9d13f863ab087d30e1df26e9d3ef53b9354c89c095dfc87f2b3debd07e744d03"
  license "MIT"
  head "https:github.comjdxusage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8cc981723501828057eaa73779b9662f389f20623e3c75942a95c3eb83d82012"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af26a32ee558534e00ab3a9062aa06c8661adeac202da65a29abcc6fa691e5ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1244f4d6701e87a04c8e2727b60d5b5244d81b1435e5eb761a19133eaef5c4f5"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9d2a7db07ba96335533bad274efa75011b33b0c3231441e862a6b838790e6f8"
    sha256 cellar: :any_skip_relocation, ventura:       "f3bb01ceae4f0e22ada3c813ca53cb2309d57797a3f01102a2eaab122c4f75be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f97fb53868a3ec268ad23a53d3a792450a6756955a130682ba7ad7461b804c71"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match "usage-cli", shell_output(bin"usage --version").chomp
    assert_equal "--foo", shell_output(bin"usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end