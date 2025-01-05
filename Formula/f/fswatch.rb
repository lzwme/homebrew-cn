class Fswatch < Formula
  desc "Monitor a directory for changes and run a shell command"
  homepage "https:github.comemcrisostomofswatch"
  url "https:github.comemcrisostomofswatchreleasesdownload1.18.0fswatch-1.18.0.tar.gz"
  sha256 "aa7454d1fc4e8f5eb0e9bd4711473c8c7c2b257e2fdea62527e86f7afaef091b"
  license all_of: ["GPL-3.0-or-later", "Apache-2.0"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "27c60ec1ec86f1f591148d396552f3e646425ba7d6a6e3dab7bb23e585578032"
    sha256 cellar: :any, arm64_sonoma:  "2ac3fa6884f326b616931d1faab671464e3a3c7b523fa8725b3975d4beeb581f"
    sha256 cellar: :any, arm64_ventura: "f83c4bf9bb82ff6760a98152f4068a1b8c72b457e1d220f5d2d1a115bc06e67e"
    sha256 cellar: :any, sonoma:        "f5678fe7400a8aef183cb4754436c01c666cc1b401b2ba5d06f0404de4ca0062"
    sha256 cellar: :any, ventura:       "b14d4ed4ab4aa2b4e8a18ce641d9d7b8f536a467cce6036ad52c84c660bd926d"
    sha256               x86_64_linux:  "33e6d0a5c4ca3534b2e14c5f4942cc77d696978be4ed41af47d1b2848bacad37"
  end

  def install
    system ".configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin"fswatch", "-h"
  end
end