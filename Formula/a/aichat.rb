class Aichat < Formula
  desc "ChatGPT cli"
  homepage "https:github.comsigodenaichat"
  url "https:github.comsigodenaichatarchiverefstagsv0.11.0.tar.gz"
  sha256 "3f6eede4300048312bd16c1cda2299d179040e1a3b2a1c37fc908db4b40098a7"
  license any_of: ["Apache-2.0", "MIT"]
  head "https:github.comsigodenaichat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "73f41cdad2e1dd3fac1d043e7c75f7b0fcc542c10d2b3a53fb17dfe42eaa3640"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bde1c3c001de75cf58a70a386b522d40c5b3030b9d2b8dab0e96d8219fd1092b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f90ace01ae741f0b6c179a069bc477d43d4a380737f884ec1129b237582f483c"
    sha256 cellar: :any_skip_relocation, sonoma:         "a90fddc017d125f78e611ad08e180d865eb52bcf8b8eee8d6812e21ba891e299"
    sha256 cellar: :any_skip_relocation, ventura:        "db275c600ccd62ccce1affd5506a6b6546aca202960c55ae9e0b181b6842be3d"
    sha256 cellar: :any_skip_relocation, monterey:       "7642e082aa41214e254c82db8371aa619ee564fd9d81c69a6460f79e19101cba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4ef0a11306518e7c7149aa7230e9eb1088c7f2433f25b4261d601dd6cee25ecf"
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