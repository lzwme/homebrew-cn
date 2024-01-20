class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https:github.comcrate-citypos"
  url "https:github.comcrate-cityposarchiverefstagsv1.17.2.tar.gz"
  sha256 "51fbd4a7276394141ef30aae0eb9a394a4602d1e851e29ba406529f964a54053"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "132f30d009295f29952f1d43a37fd5a587c49e9d55fd8c4d1e21a6d652e4f26c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b17216d982a8e446ba333c4051d5ca421e6b01a36ee9dc22597ad5735db1ba55"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba89097e824b1fe6f52d94d1af749ff6753e48769af4f631240f8c30eaba1c6a"
    sha256 cellar: :any_skip_relocation, sonoma:         "4c7b8c03a10e17427a6523c41f801e4b03c804527c03844b910324444ea09109"
    sha256 cellar: :any_skip_relocation, ventura:        "b2a4c2fe75430461ef62a74850d5ff537c0d6198532145f09d264c2280991aa9"
    sha256 cellar: :any_skip_relocation, monterey:       "039fd4182cbf7eb1e9da909d8343f8150c1114d6660ad7d6f64adf9dbcd2912f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ccb8d850d49fbd99ade675001725d7d5e0606df7a5bb1f398a6d7f3e67c40cc"
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