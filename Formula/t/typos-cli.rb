class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https:github.comcrate-citypos"
  url "https:github.comcrate-cityposarchiverefstagsv1.29.3.tar.gz"
  sha256 "f7c8ef65193e4537475addde8e3e9ea0c83515b1f478ad07915250ae05263258"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c46230652d5ecb4b571e0741320c0f9f993f4787a97c24a9424b33d39b61a94b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cbfc581ec4d96ebe6a290a2b2c2f410ec7830fc8ca7330e155527e50ac410b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ba1e231161f44100229fa33836a421c7554c4c35c3fb172a0f6bfa8111207f9b"
    sha256 cellar: :any_skip_relocation, sonoma:        "34dbb0fd7d740ef9a0307a897ff126e88d877250aec4b98fb584d8aeb493dbda"
    sha256 cellar: :any_skip_relocation, ventura:       "6deb81a30cf435de18ef2e3636508b312689ac14de4a5255ca4885aa5d7d5519"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8737b1aabc8783a5b499259ff5242be9a1a65cd5380b9b3e780895b1ea2439cf"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratestypos-cli")
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}typos -", "teh", 2)
    assert_empty pipe_output("#{bin}typos -", "the")
  end
end