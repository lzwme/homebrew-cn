class Rtx < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://github.com/jdx/rtx"
  url "https://ghproxy.com/https://github.com/jdx/rtx/archive/refs/tags/v2023.11.2.tar.gz"
  sha256 "28cecfc9062c849d5ab998fc748083915347cacc402fb83bf80ce20a40ec4f40"
  license "MIT"
  head "https://github.com/jdx/rtx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e58b5db89a2a6069446521428afbc57a23bd8182a040e41b1048d672f07108da"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7213b2ab85114768249ce964f348999f181db9c2121c0a3ec7781d4e5b29be4e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "274cd0329cbcbdbf4286437078c91de80f6303372bf01ff412735db37597444c"
    sha256 cellar: :any_skip_relocation, sonoma:         "b34c7facfdf063e4b752dac21786cd6f39addb5a1902c11d0ccb6422e2b9d5cd"
    sha256 cellar: :any_skip_relocation, ventura:        "6f426d327dbb35389cf90770e1840b853911225cecebc9b534559a8c4a1af018"
    sha256 cellar: :any_skip_relocation, monterey:       "bae1a45352ad4bcc9e9f105d4fdd976a37a84507821f92fa1b58367501a04d11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffcb9272f54bc2b4531ec020729cf43fd12f0ce710eca663392959d0ced47b97"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", "--features=brew", *std_cargo_args
    man1.install "man/man1/rtx.1"
    generate_completions_from_executable(bin/"rtx", "completion")
  end

  test do
    system "#{bin}/rtx", "install", "nodejs@18.13.0"
    assert_match "v18.13.0", shell_output("#{bin}/rtx exec nodejs@18.13.0 -- node -v")
  end
end