class BatExtras < Formula
  desc "Bash scripts that integrate bat with various command-line tools"
  homepage "https:github.cometh-pbat-extras"
  url "https:github.cometh-pbat-extrasarchiverefstagsv2024.08.24.tar.gz"
  sha256 "2ff1b9104134f10721ef36580150365e94546e5b41b9a2a6eaa4851c5959b487"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3f77d56bf671e40f980d54be6fe95db9b75b4846544d1551366a7c952972d864"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ffbc0b06365560c945e7ba27da1e9416e2b28ee1dbc719d63672f797293668c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2887dfd67a998d9fc5e9631463074f2361dea63e878bb1b8f6cafda07c1cada4"
    sha256 cellar: :any_skip_relocation, sonoma:         "ad0c1049cd4c49a98517ab67a2bf6f9e5b4304ff26e2b930216e3badb069a054"
    sha256 cellar: :any_skip_relocation, ventura:        "eba7f97907ba5dc853dcbbcaa038d5e6f77e1929e50088c715ba51476de51855"
    sha256 cellar: :any_skip_relocation, monterey:       "cb838dc35e747b7510d75e919449059858f676d31265acaa5445d234e759902f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "493e6115711432e8e2cc3527b3660bb47762a7e609d16dbdc19cbe8d6fb61307"
  end

  depends_on "bat" => [:build, :test]
  depends_on "shfmt" => :build
  depends_on "ripgrep" => :test

  def install
    system ".build.sh", "--prefix=#{prefix}", "--minify", "all", "--install"
  end

  test do
    system bin"prettybat < devnull"
    system bin"batgrep", "usrbinenv", bin
  end
end