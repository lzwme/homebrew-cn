class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://mongodb.github.io/kingfisher/"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v1.105.0.tar.gz"
  sha256 "3fe56500fde1c300baa1ec1e0e802b019dee0bba73777e0a6a6968101e50940c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63635bd656eb47395bf9f6722aebcc22548c77f205bebac1034ea925cd4df649"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fcabc4c663440ecf28f6a1a760925cb4336914e50bfe8baa8f0b46eca0b0c7bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "247dc28e7b0214dfea9e56854e0c05a50eca6a6f6539aedcc771911067552804"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb0775ea96c4f6066c4e77db25df38b37639985936a98fb8f67abe33813ae173"
    sha256 cellar: :any,                 arm64_linux:   "91ff5f938b2491829cd0f4d4607206043d6b52ff98c8943c3eb6cb2fcf33f186"
    sha256 cellar: :any,                 x86_64_linux:  "9f6eb0743cc8461815391ff6ae28e11d5c745384edf86967dca79fd213d26e74"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  def install
    args = std_cargo_args
    args << "--features=system-alloc" if OS.mac?
    system "cargo", "install", *args
  end

  test do
    output = shell_output("#{bin}/kingfisher scan --git-url https://github.com/homebrew/.github")
    assert_match "|Findings....................: 0", output
  end
end