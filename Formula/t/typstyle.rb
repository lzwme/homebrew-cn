class Typstyle < Formula
  desc "Beautiful and reliable typst code formatter"
  homepage "https:enter-tainer.github.iotypstyle"
  url "https:github.comEnter-tainertypstylearchiverefstagsv0.13.7.tar.gz"
  sha256 "594e5f65d458250422b4eb05ad66dfbaaa377df97ed88a43f7bd0530c8de4ed2"
  license "Apache-2.0"
  head "https:github.comEnter-tainertypstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce1ddb6165b133b9a2e1bf113e11c70049edb36c91af495d56e3c6c2bcaa00c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb157bd3f354577395e7b0dd957900324733188d32692cdedd92fee15e715284"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ea440e2dffd14163eca4c6faa2426693d41f81a0d83ccc2c62123bc4c3dcea58"
    sha256 cellar: :any_skip_relocation, sonoma:        "5ea3226695f2f17b325940375a80d848607be00c5706c66d04325637c79fe428"
    sha256 cellar: :any_skip_relocation, ventura:       "34cf990088ad63d47abebf16a1b2dc840a1a744a2ccbd7b058bd257d40ff6d1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb7475e15b4763a62fcb35af844a36d37e4da08c26a533f9f97bca0e027bcb94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ceca84d675c2ef5e9edbf94cb086d9f79781fa4d0fbd0e81177b1b2a73a71cc"
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