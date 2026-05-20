class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://stackslabs.com/"
  url "https://ghfast.top/https://github.com/stx-labs/clarinet/archive/refs/tags/v3.18.1.tar.gz"
  sha256 "21dd97c32c96c9884722a1025739b24b68526bbcf138c3bd6cf7cf46b2b2ff4c"
  license "GPL-3.0-only"
  version_scheme 1
  head "https://github.com/stx-labs/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5b2d3b6d64a45da5819b627c605a49ad6bdfc052d71a817e9c74c063cbf87a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8190671d3b77995b0c5f7612b5dc780a3a8471b5e7114575711d88582fce7680"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dae7c052c5a0199be9a17404a103cb5c4257461947af463ab3536ee5832f3676"
    sha256 cellar: :any_skip_relocation, sonoma:        "0056cfec662a1addf76b9db1da47e720605132f267a407629bbe65568908f3bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77c9c153671fb7bcbb05bd98a75fad0f6f0046c018e816af35e617c78211c707"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fcce263a272d8484bc675aff46e668c488280a73de4e67af25808f794e5d757"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "components/clarinet-cli")
  end

  test do
    pipe_output("#{bin}/clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end