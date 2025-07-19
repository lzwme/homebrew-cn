class Spacer < Formula
  desc "Small command-line utility for adding spacers to command output"
  homepage "https://github.com/samwho/spacer"
  url "https://ghfast.top/https://github.com/samwho/spacer/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "7408b9ebefac040110cc3f4ee12ccdc320ca8aa88f9d306304f3e8878103fd10"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad8663e1483bb6dccc18b94bd4c7ae8a633e3e31f8c4ea05037ce7f5b7955592"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce31df01e013ebc163b73ede478d2ce095746e8453b8d931c0785be40161f758"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "115bc2b194f788ecc8569ebff7397b5c8a2154d78c41975124c892db7120c1cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "14db5782e8ae633f92f53770dca37f1b1a4785753063a4c43e64a00747f7c7f8"
    sha256 cellar: :any_skip_relocation, ventura:       "84d388b3ce2d6beedab69386f8e8819d3bb47e04cd8409349f81a3f1ca14965e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5939dee33629f72cde4f47a2d98d79e8a5a34ea854143adf24ad904c7cee384"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e93f5f93539868f518f3c475b9a9ab25edd77222e518e2d2983138e760db4ac"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spacer --version").chomp
    date = shell_output("date +'%Y-%m-%d'").chomp
    spacer_in = shell_output(
      "i=0
      while [ $i -le 2 ];
        do echo $i; sleep 1
        i=$(( i + 1 ))
      done | #{bin}/spacer --after 0.5",
    ).chomp
    assert_includes spacer_in, date
  end
end