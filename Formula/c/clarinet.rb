class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://stackslabs.com/"
  url "https://ghfast.top/https://github.com/stx-labs/clarinet/archive/refs/tags/v3.14.1.tar.gz"
  sha256 "35ed02faec2cb37a3898a89280359031d22d78c45692eb1cf100c68aaff9f525"
  license "GPL-3.0-only"
  head "https://github.com/stx-labs/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3941d768095bc5dc2f37bcde92c070572f1c617e9835fac8176e3c5c48f22d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f73f2a2686bb403ae48b1677b65cc1ad450345ff4bf03675923e871567b3bbdf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f4cc7a18bff87e09a42e9f06c71aa5ae24b48de1623bb99cec084265edb8d13"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d60873c3a1746930be801dacae40a5e48435d85f09c7d66caf2bb37ff5db6b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea3a5783f1cf1f0a1c5a95dc93a48840e4c937e66ae724c8b049fb11545428b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9bb69f8daf2b5f2123dae3590777ae484d08279b082cfcdb8e2f0804b4355b3"
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