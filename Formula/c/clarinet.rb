class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://stackslabs.com/"
  url "https://ghfast.top/https://github.com/stx-labs/clarinet/archive/refs/tags/v3.11.0.tar.gz"
  sha256 "654771053931d08d2ca679ca83bb0f4da149b6d5dada2228549d0a43e53087a3"
  license "GPL-3.0-only"
  head "https://github.com/stx-labs/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89caabd8da5ad581cfe7cdea6f9e715ce778f40ccfcda32898aa6e8b6130d3a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33111e3ea15f8e4cf10fba7e679cdc8ad1184a08a1ace1cdaf65f7cb6e510e3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d55b41686d7b58e4dd73522cf2c5fceb6afa6aeecddf877023707a6f9c7dc548"
    sha256 cellar: :any_skip_relocation, sonoma:        "52d0e6fa745688d247b5761558158a79302023c506956fd5d253115f0388e209"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff318671af054f79d33d4fdf35c0bc2eae42ffcc91d9554a62756185b4523bb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f522f0a780afa6cd184136c17bb73f1a6fec0bc4365c07ad1cf613e843c1cedd"
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