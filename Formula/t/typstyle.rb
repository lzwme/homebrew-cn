class Typstyle < Formula
  desc "Beautiful and reliable typst code formatter"
  homepage "https:enter-tainer.github.iotypstyle"
  url "https:github.comEnter-tainertypstylearchiverefstagsv0.13.8.tar.gz"
  sha256 "ffc4425007fc7b066029bee7899041048869584f8b84a6165eaae461b772433f"
  license "Apache-2.0"
  head "https:github.comEnter-tainertypstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91f4d951727410f37229bb24f1172ddca5720aaca6b81f55fa461c9c7e62f2fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf96673db3bdab42f1e7ecbcf335f6deea95fa2a5c6ac070e5042daa24921f46"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "31003d03cb51ae855562a4ea84acfb540baf254c5ae1a1793fe57578e03d7d3b"
    sha256 cellar: :any_skip_relocation, sonoma:        "322ec10a13ef70bfac440929e46167352d153ffd6d54547c180aecd000576f8d"
    sha256 cellar: :any_skip_relocation, ventura:       "64fd215ec237909c50301c68c695e35c0566f6fa09501b87da68b41d86b6ab45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "adb622e51367362bc896e47a4893717c5b4d05fa06114d360f4190c44e1401a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e07c63bcacb6b351ee2dda128d5cb972ee2ace1520a8f8c3b125b749a159ac1d"
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