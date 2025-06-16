class Typstyle < Formula
  desc "Beautiful and reliable typst code formatter"
  homepage "https:enter-tainer.github.iotypstyle"
  url "https:github.comEnter-tainertypstylearchiverefstagsv0.13.11.tar.gz"
  sha256 "7a7bff0980f00f468dfadc04e2c26531ea7d2301b2909bf2cb24116c97902ec7"
  license "Apache-2.0"
  head "https:github.comEnter-tainertypstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4a5153fabe08e2a9e18f951d222ee7486e09acaada785e90a864bf0c74dd2fd8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "358c54239c81572f8897829d696c13c6a6db7f3d629080975b648e9549d4fc42"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "966f5f8f1582cfd5b106344ee66d40c39dc9d4c41c205e5fcc09c2ca3e0a0483"
    sha256 cellar: :any_skip_relocation, sonoma:        "ab7cc4e8410c24af4e70d53ea7a1f7d87f80025c91d69b898ea8fe68642503ad"
    sha256 cellar: :any_skip_relocation, ventura:       "1a6014a7792b5f967a59da730332117fddf78b379a5594e4b432f789320be1fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "96dc100d89179c2ef89027e4607401cd2e660c5b28716ab0d8644828634980df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10590134a62e429642717b8d2881442d3778eb7d5389b4739aa2939553d74d39"
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