class Typstyle < Formula
  desc "Beautiful and reliable typst code formatter"
  homepage "https:enter-tainer.github.iotypstyle"
  url "https:github.comEnter-tainertypstylearchiverefstagsv0.13.6.tar.gz"
  sha256 "3ecac7ccd9e8e6d3ac5750b3036dc0253a4a228c9270c14e0a499c6ae677eb42"
  license "Apache-2.0"
  head "https:github.comEnter-tainertypstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "992fd5377b38e16f85a43d507683a366c5c6051c4dd3c638a6a0a761b3e860fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56f2bef0e58ad6f25464493072f77a9999cef64f7e98de07c18c02171272c26e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ed361443496a80b32b8c279a7ab948855845ad529018abd702256d675b4b3631"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ea2dabb2eec0ffedf6ad747aeb11aaf7d0f2908f36ce293c045cbd619928080"
    sha256 cellar: :any_skip_relocation, ventura:       "22c42c44cb0ac6a0170b001fda02b3a5a977ff9e7799434064b447b199ca333c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80c72b80e59fcb067edadf81d3e7061871556c23bc1faab7da3fc891c4fe7854"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01bf5a113113054d4701097db35e15d40bce77d801a9b8926a5294e249e41553"
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