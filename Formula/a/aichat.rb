class Aichat < Formula
  desc "ChatGPT cli"
  homepage "https:github.comsigodenaichat"
  url "https:github.comsigodenaichatarchiverefstagsv0.15.0.tar.gz"
  sha256 "aa235d15d7a7f00e023d141eba100f329b33d56cf9fb32936f3c3ee652b7c65a"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comsigodenaichat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fbc88f3e0709ee53270eb97c5d12a7a15b401f034b937b5c5b9b5fe2b8af2a5d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e245fa3409005adc28258f21bd55686bc2b3a9eeba002c257b2eadf91226e180"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3f198d72eca916f154de38777c96e10b5eb6192b833de75c1bfa27b0f9a6c02"
    sha256 cellar: :any_skip_relocation, sonoma:         "e86d2dcb5c12d36f683a7b1c5f5f0897f199e2ecce43a673e2d9e081c3c246bd"
    sha256 cellar: :any_skip_relocation, ventura:        "6d34f6c21095e935eeeddd93c4331d23837214f09dbf4b66f0e10f8f01aaf531"
    sha256 cellar: :any_skip_relocation, monterey:       "583bc3933bc180a4eedd56fdc2076982c83785a0cfdf286663ef5c9c6906711b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a06c8ddb669812f41afbb50793f0c0616f65a5bd35e956244cb5e5e3a46939e6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["OPENAI_API_KEY"] = "sk-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    output = shell_output("#{bin}aichat --dry-run math 3.2x4.8")
    assert_match "math 3.2x4.8", output
  end
end