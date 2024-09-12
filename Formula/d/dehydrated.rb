class Dehydrated < Formula
  desc "LetsEncryptacme client implemented as a shell-script"
  homepage "https:dehydrated.io"
  url "https:github.comdehydrated-iodehydratedarchiverefstagsv0.7.1.tar.gz"
  sha256 "3d993237af5abd4ee83100458867454ed119e41fac72b3d2bce9efc60d4dff32"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "23a0b86ce9fd4da089669866a366e1adf806899e472465005c3c998af304c588"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8b4325b8a1902d492ba021b0889fb5a91b59a26899569cc351be4a4a52e3d4f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f17795e23bdd54c28ee3b776ca2a23961d82ad07dd28b9d5081ae8edb2dae79c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f17795e23bdd54c28ee3b776ca2a23961d82ad07dd28b9d5081ae8edb2dae79c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f17795e23bdd54c28ee3b776ca2a23961d82ad07dd28b9d5081ae8edb2dae79c"
    sha256 cellar: :any_skip_relocation, sonoma:         "3fc1267b8ea7543354b58440605dcafee455c6196943e324bf049c836445f970"
    sha256 cellar: :any_skip_relocation, ventura:        "ebef64bfbbb961baab69a546da164867b6d3d0acc2090b6f0a8d9d1b2e6ac26b"
    sha256 cellar: :any_skip_relocation, monterey:       "ebef64bfbbb961baab69a546da164867b6d3d0acc2090b6f0a8d9d1b2e6ac26b"
    sha256 cellar: :any_skip_relocation, big_sur:        "ebef64bfbbb961baab69a546da164867b6d3d0acc2090b6f0a8d9d1b2e6ac26b"
    sha256 cellar: :any_skip_relocation, catalina:       "ebef64bfbbb961baab69a546da164867b6d3d0acc2090b6f0a8d9d1b2e6ac26b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f17795e23bdd54c28ee3b776ca2a23961d82ad07dd28b9d5081ae8edb2dae79c"
  end

  def install
    bin.install "dehydrated"
    man1.install "docsmandehydrated.1"
  end

  test do
    system bin"dehydrated", "--help"
  end
end