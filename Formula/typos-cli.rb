class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghproxy.com/https://github.com/crate-ci/typos/archive/refs/tags/v1.15.5.tar.gz"
  sha256 "65f6c1e2fe8b65593e981e72e8cb8b9ea192d2dc2c885d8cb972bb44d6f603df"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d28ed72b0afc890aa5b645d6ed80d13085e92520f79dafbc9067f750603aa033"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aaf54cf6791b4ffcb41b8f9d2a7ffb26591488533ccdd68df37a3d218da2eeb2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f1443a37e0d297002e39d2737619c798adef9af8febf67c069ae6e227508c342"
    sha256 cellar: :any_skip_relocation, ventura:        "14d1c174ef8ae90401a34d5b4aa20fd4dd55900f3a44a819c0dd16ba0ded320f"
    sha256 cellar: :any_skip_relocation, monterey:       "16038536a6c337ae631dbef9c98d8dc6747a88a0f82849eee35d9ae6e165df4c"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff83a441fcd05760e8080c75c5bd35f6d49ebda4edce2f369bdec306b0f1ee52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a68d8fb1e01d021b6417df7337b0d2017a9f87d101468fa5752ae9777932adce"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/typos-cli")
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}/typos -", "teh", 2)
    assert_empty pipe_output("#{bin}/typos -", "the")
  end
end