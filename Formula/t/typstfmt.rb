class Typstfmt < Formula
  desc "Formatter for typst"
  homepage "https:github.comastrale-sharptypstfmt"
  url "https:github.comastrale-sharptypstfmtarchiverefstags0.2.8.tar.gz"
  sha256 "0c884ea06a8f1d04fa12ea582f11b3520e09c337fb42855b3b49175f1e4b8a57"
  license one_of: ["MIT", "Apache-2.0"]
  head "https:github.comastrale-sharptypstfmt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c619778606e38d324e61afc769d554abec2f5dd066d15050076b704f6b481e6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b10bd3de1303cdcbe9d532a89fcb6c0d337a2bfc05822e351ad48711b29fa929"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6e676dd48c4695687b86412b5e14b03631f71918b5aec40155afbaf2e469467"
    sha256 cellar: :any_skip_relocation, sonoma:         "f1be979d0bbd78dad8702fe7de39256376b52fc2caa68b3023c5c0cdd742de77"
    sha256 cellar: :any_skip_relocation, ventura:        "6b4c0038acc7590024ad55af1c1ef26bec59c1924c97a18749b752cfc21846d8"
    sha256 cellar: :any_skip_relocation, monterey:       "de25a5e37032bae1f4e88e384c6eac9e7fd6d165b59720211d95493e407b2df7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e828efb433a5f1701d728b52a850d958e1aadef8b4cd39b1f8cc8b2dd267d130"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath"Hello.typ").write("Hello World!")
    system bin"typstfmt", "Hello.typ"

    # https:github.comastrale-sharptypstfmtissues155
    # assert_match version.to_s, shell_output("#{bin}typstfmt --version")
  end
end