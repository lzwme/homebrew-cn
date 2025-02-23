class Typstyle < Formula
  desc "Beautiful and reliable typst code formatter"
  homepage "https:enter-tainer.github.iotypstyle"
  url "https:github.comEnter-tainertypstylearchiverefstagsv0.13.0.tar.gz"
  sha256 "2a57d02df94d50e7b0e721ab0d3e6139a1ee892b51a5afb6e1ea8c62f637151f"
  license "Apache-2.0"
  head "https:github.comEnter-tainertypstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e505606a189142c8ca39b747c8861637d20b982921d99b3f37f3dc4b9be380ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1435d713f8d4156d7cb58d55ed6c363195be5429cca8be67dbf5da8c61617e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "192900539183a3e62aab7310df3347d76498f89477eeb8ba7c035f25c9cc4c62"
    sha256 cellar: :any_skip_relocation, sonoma:        "ad26eaa6428cb4b797b957b7a02f9a9469fde14ad42026f5ac3bb73505b96805"
    sha256 cellar: :any_skip_relocation, ventura:       "e958ca295029509f8e486a5b507d7a3beabf3f57cb9d999b6a397590764e06d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3be84f869752d693aec00c8c8689f85068e6fc31a6f6bff632d27c67866ade39"
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