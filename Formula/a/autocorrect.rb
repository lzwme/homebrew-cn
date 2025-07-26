class Autocorrect < Formula
  desc "Linter and formatter to improve copywriting, correct spaces, words between CJK"
  homepage "https://huacnlee.github.io/autocorrect/"
  url "https://ghfast.top/https://github.com/huacnlee/autocorrect/archive/refs/tags/v2.14.2.tar.gz"
  sha256 "3f775fe9e291ab3291d6263bd9904d178af3fe937333eb1cd8f492679bbb35bf"
  license "MIT"
  head "https://github.com/huacnlee/autocorrect.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39ec38025005efc88a335243d5d56b5755385c28e50f7ac3633ec1294223245e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ff855b887e9af07bffa23eadbc0f968ce0a70f99ab691e0f9b3ae6d0c45d944"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cc59c0f4ca11e89a502aec28ebcfc9252dd9e33d0ca0934bdeef3cc80516a9b6"
    sha256 cellar: :any_skip_relocation, sonoma:        "73cb7560d791cf3979575a955fac3687930cf8f82e64d4cf49a73a022fba2edc"
    sha256 cellar: :any_skip_relocation, ventura:       "9e6d6cc2ed8cc34dd0ef72578811711d3189738978afe50ca98101088ffb0027"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13b4a707c8c4ed862d10c50de7f99d226e61e6fb03d0b922b61eae8813de001a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b52b3451f9918de2e01d1d7a1efd819caede841e5ffbf4e07b813308a9a58aa8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "autocorrect-cli")
  end

  test do
    (testpath/"autocorrect.md").write "Hello世界"
    out = shell_output("#{bin}/autocorrect autocorrect.md").chomp
    assert_match "Hello 世界", out

    assert_match version.to_s, shell_output("#{bin}/autocorrect --version")
  end
end