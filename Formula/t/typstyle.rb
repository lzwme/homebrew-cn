class Typstyle < Formula
  desc "Beautiful and reliable typst code formatter"
  homepage "https:typstyle-rs.github.iotypstyle"
  url "https:github.comtypstyle-rstypstylearchiverefstagsv0.13.12.tar.gz"
  sha256 "8d93a76f87c3b6268dc55179ad2ad235a9a56593714925a6b463354ad9931bb8"
  license "Apache-2.0"
  head "https:github.comtypstyle-rstypstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a4093ec76e16ec000a50319d597bf5749c2cb2230d95532b23fda8552489896"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6cdd4a07f69863ae9e45ea3947616c86dfab0e48f4cd686fcef27142cfe062d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1890ce19dc9a558e4190f7439314725b8e61f54933ab9fdb1c529a4036458ecc"
    sha256 cellar: :any_skip_relocation, sonoma:        "334c6ea7b543c576a616b55a16271035be849a8364680a2b08ec84b4e5b78ab1"
    sha256 cellar: :any_skip_relocation, ventura:       "641da1444794a221cd58929851dfe37c4f1d91655e16da59da8aebabf8e6276e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "675f3abbaea02606dde822fe4ccf0cd9a90883f4dabb34203a9ef31418291a9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36fe535bffdd8e45c6e62aab81c84846f5acd33185dd39d76bf6ede22c1ab801"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratestypstyle")

    generate_completions_from_executable(bin"typstyle", "completions")
  end

  test do
    (testpath"Hello.typ").write("Hello World!")
    system bin"typstyle", "Hello.typ"

    assert_match version.to_s, shell_output("#{bin}typstyle --version")
  end
end