class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https:github.comcrate-citypos"
  url "https:github.comcrate-cityposarchiverefstagsv1.24.6.tar.gz"
  sha256 "3ca3815e7c6efe627878e183ac90f4150fdb9c1372c27535d66eee625be8bdd0"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca602bb88b090638b1c19cfb2e349a7ec52007fa511447ea650456462a428ab5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbe36e809f3d258d4dc7c8d5dbe513a49243ecf5f851e24bd91bebef7006999d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9d8e13a41b5cc299503acef3eabf1ccd9a9cf1eb521529c953e32a6099ab9e85"
    sha256 cellar: :any_skip_relocation, sonoma:        "160bc5fb19dec48aefae26b4ebe318f616270de1ee1fe6a1c0aeb7c8594bfd4e"
    sha256 cellar: :any_skip_relocation, ventura:       "66ca295b35db75b2c6c0829c2fc83f65cbd5ded0c44de11e96a7847bc265c0e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2d8b2b631d3ed6a5bd7fc2d08fa4b481a1f766a30854e5aaa1d5f1765bfb60c"
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