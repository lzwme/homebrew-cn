class Fswatch < Formula
  desc "Monitor a directory for changes and run a shell command"
  homepage "https:github.comemcrisostomofswatch"
  url "https:github.comemcrisostomofswatchreleasesdownload1.18.2fswatch-1.18.2.tar.gz"
  sha256 "1e5ec35c0bd8f39d45cb326e85362a0472e6b6b5a65eca7934c357e54926dfeb"
  license all_of: ["GPL-3.0-or-later", "Apache-2.0"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "6be389864292dde6b3c0dddc1e49526b16c268c74883b7870dab4c30fe984e6a"
    sha256 cellar: :any, arm64_sonoma:  "aa63026628cc6e1c90eda516154a5325bccf356a492e6023e4ffa6388d240c98"
    sha256 cellar: :any, arm64_ventura: "f191a3440e9f4530666f4178666690dea983db5e930657ecf7d403c619b76d1a"
    sha256 cellar: :any, sonoma:        "ba69935f4fbd020b5be907d73fc46a98c3d1402f587cdf08c846187cd4ff8572"
    sha256 cellar: :any, ventura:       "89c2390e3b368f922280a3c287d4c17049adc67b87579afa71b3a90a9bba1b3a"
    sha256               x86_64_linux:  "b7714de26333fb00bf33ac6ebae5260e50bbf8045dffe9ac8535a5aaf83019d1"
  end

  def install
    system ".configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin"fswatch", "-h"
  end
end