class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://stackslabs.com/"
  url "https://ghfast.top/https://github.com/stx-labs/clarinet/archive/refs/tags/v15.16.0.tar.gz"
  sha256 "ae6d5745c0c917ac2bb31f004a24ba8810d8f701e217ef852c014e8f4b51bc19"
  license "GPL-3.0-only"
  head "https://github.com/stx-labs/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f62a490818fea2ce6a4e753b6bbf96848ca7870bc818789b5dc9f9699f03efd2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a65f71d3b0f08cdde26e201642388ec5502e4cfd3ad15ea8ec5d1c5263c8c93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48833f760c850659d04f65fa9ad3829137872f69c3554752733ad7aba9da36e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "45b624cb63fe2ad93fd42d72f7844025c61746db2d05604a456fd5289071841b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a6dd9ce24715efb4d7fc7ae202827781bb50763c4f3d7d3136591c6c8d847e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3616cf850b08701961939d595ad2927c532520775b02fe33c93957aed1270492"
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