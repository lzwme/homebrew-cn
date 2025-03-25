class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https:github.comcrate-citypos"
  url "https:github.comcrate-cityposarchiverefstagsv1.30.3.tar.gz"
  sha256 "560b564eb7c98ac553859bfb2fcdb58ef2d09c464398ef80fa727ec43293f332"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ae7f0e285a55dde913a17fda62aa1b1dce21cb7c2ed72a600f2b1864cb339fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37b131ce8bba69a34853a004de97fd7e6465253282fe5bdedd5ca997ffda9b9f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "15dbe2e023ad3bcf7e2294f1e57a083195cd7eb8c5c3baf78a6849d6449f9a5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce2487de2cea1760f9197b61f85be5b302621a4821ce8fdc714a92b9fa095a88"
    sha256 cellar: :any_skip_relocation, ventura:       "9451e405aed86af3209e09cbc328d15d13c7fe163b516fe689717640a9416935"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f4e3492ae5d34f268e9bc618b8448f195e05708b0f123cb5344ca2050060914"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcfaf1d06590a4a51b364ed0122c5d0e462b793fd0139c8bfcf881bf90d4d467"
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