class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https:github.comcrate-citypos"
  url "https:github.comcrate-cityposarchiverefstagsv1.29.10.tar.gz"
  sha256 "4ac97632dce18fdc7c1d6362ff4bc62afc8a8176218e043eb872267432fe145d"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "730010cd4c4e9230b15d7a9bbd7b39c67c0c46c2c7b184eef9042b4495db81ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73f6565dd310c72d7c32fec28222bf785406f77a76129873bc448f654e9ecc07"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f4225213a378140763b9fb626249362512f4a442b2d9919175a3748a5a022d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f43326eac60fbaa1cde9164e93620065073264a7799b9b1077b4efccb1eeba8"
    sha256 cellar: :any_skip_relocation, ventura:       "893005e58344fa2e875a3c45b84b4d422db850ae0e04ba7d4fc489b9bc3271d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "832cf36ac655f39572fd7db393705bdedb9a1f9da16f67581e1b1fce50fcb2ea"
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