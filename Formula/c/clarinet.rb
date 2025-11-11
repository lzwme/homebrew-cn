class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://stackslabs.com/"
  url "https://ghfast.top/https://github.com/stx-labs/clarinet/archive/refs/tags/v3.9.2.tar.gz"
  sha256 "7b6dfa7e7f3d62a946f90623d6fa48f3e21fb5e6aee233b74c68773b425dba4f"
  license "GPL-3.0-only"
  head "https://github.com/stx-labs/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8f154286e36d2b4ce0f72685c1acaf1e65f1614f9698a3bbc586f07fe4b47ec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25699e59e3df8f1a4bbd34fde3d17f8c31e5d5e95ccfa437bdb7fd7ae3389639"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9faafe5cdb5196029cd24a7278bb58ce2995caddc1d381aba013cc8963b1f00a"
    sha256 cellar: :any_skip_relocation, sonoma:        "86b3a2bb9a17d7b95bff0df069c507cce18fba5848e63860fd98f7fa7a87a77d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ddc763f3e30c86b08d777a57a841d38bd13b81e1baa5675b17d20dd8c59bb8c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c68a30ccb10a126e2d230892439c9e29ae8c2df897dcd224120c54083e507c9a"
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