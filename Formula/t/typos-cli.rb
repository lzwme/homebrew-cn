class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https:github.comcrate-citypos"
  url "https:github.comcrate-cityposarchiverefstagsv1.22.0.tar.gz"
  sha256 "7b288479c061b7794d551f7614c95f8e2e6647350fb789702a0272c5a634b54d"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e0a43d21e4fd3ea2e132738ca44b5ea51b240a75e0ff9d9ad7b431daa4c08cac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb1644b48a19e9856ce727bb60d39718390fc8ef535ebf31768d0fb0b9fbab9a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "704bb6e61d39b0e9c371773c425798de7cc7194010e4bf3a695234c179accb83"
    sha256 cellar: :any_skip_relocation, sonoma:         "d089f585db80ad26d8e6a0039cb752a922f16a29c7bb1e2bc71ee000df50f069"
    sha256 cellar: :any_skip_relocation, ventura:        "8ecf22a1a2104d309a3e66db6ff6dd7988297b5be789181c9fad0cc0f1030d5a"
    sha256 cellar: :any_skip_relocation, monterey:       "0c94f59ad506a4e66b93e035dde15a8ab55fec8e8c91a6e3e0346264870a83c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d050d0e2404f41633f43f14d132c21aa9ab87530b4689fafd65cd7978aba954"
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