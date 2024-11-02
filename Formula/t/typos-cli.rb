class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https:github.comcrate-citypos"
  url "https:github.comcrate-cityposarchiverefstagsv1.27.0.tar.gz"
  sha256 "2f2799f9123e5af923ee646341a59a328cce71c8a875a8df69caea91261b9c79"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "040f6e3814117ab353df69bd35efcc195f0285128b1a34940adceef49583ac34"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "23d7c74ba23c56839d18934fce17ff76d63f975746782a994e4c3538d6324726"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6c791b9e5de1901afd79ca19ad4156775c00405fadb7a9648291e20abb26a497"
    sha256 cellar: :any_skip_relocation, sonoma:        "fab6d2b98a9bde87f79c2d5fa3af465670310068ba93988cef04f344fca1058f"
    sha256 cellar: :any_skip_relocation, ventura:       "064a6e3058300fa4b396384ac40b9ef0c54d79cef1ff884bfbb0e34829e662fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "486e00698e84ece6d52d99fbe5812092f184243a1f970299e3533ad123f30700"
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