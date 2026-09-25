class Kingfisher < Formula
  desc "MongoDB's blazingly fast secret scanning and validation tool"
  homepage "https://mongodb.github.io/kingfisher/"
  url "https://ghfast.top/https://github.com/mongodb/kingfisher/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "75a0f278623f7900b9e2e15ad860a1ab110051c27461ba785fa2992235855664"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d5418c671eb74f39cc3ad83f0909eb16cc4c6a0a2280a60919b275d42c8684e3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "738bda022f4d96c6917ea3d9e9db0e15e83d803005110af9bfa951cbfdc3464e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "457ce643300358d95b6a45811ebb74e1012f26b09a19b4b527aa95ea450e85f6"
    sha256 cellar: :any,                 arm64_linux:       "acad87e21f2d99703cb3224cca3552d1435f0f6c4d41bbefff52b8a521eb9881"
    sha256 cellar: :any,                 x86_64_linux:      "4f13b7216b032c5bf3c2657b122b64c5f61392d9ec9b74c34d8f9a374cc6bbd4"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "openssl@3" => :build
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