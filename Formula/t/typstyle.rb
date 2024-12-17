class Typstyle < Formula
  desc "Beautiful and reliable typst code formatter"
  homepage "https:enter-tainer.github.iotypstyle"
  url "https:github.comEnter-tainertypstylearchiverefstagsv0.12.12.tar.gz"
  sha256 "ceac34ab9e51dd770c8e2cb253b9a218a2062e778298d381435c1fde227bbd20"
  license "Apache-2.0"
  head "https:github.comEnter-tainertypstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5da99c675f93acd65f37f527b85b865c0754aada7e96c985c50718ccd5f4069b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ba9c93bd027111d44c27a3ccdff5954a688b2f64e938ab34e22b113ec055c18"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "69e73e2ec61294439777ee19365a03b5ce95569a0e720337412bc1827ba3afe9"
    sha256 cellar: :any_skip_relocation, sonoma:        "eda2e316ebe59ce447178e350fbed25c4673526c076b70d1a5821143dbf0c825"
    sha256 cellar: :any_skip_relocation, ventura:       "0f7a03b2c362bf234e2a4b018224f319ee48fb7bb48b4e0ce648be50db79765e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9529a1387f84f5bc74b24f8dc6d146b52f5ab1136f47758aa3ea5408f333cfc6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratestypstyle")
  end

  test do
    (testpath"Hello.typ").write("Hello World!")
    system bin"typstyle", "Hello.typ"

    assert_match version.to_s, shell_output("#{bin}typstyle --version")
  end
end