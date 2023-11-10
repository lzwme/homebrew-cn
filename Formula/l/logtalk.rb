class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://ghproxy.com/https://github.com/LogtalkDotOrg/logtalk3/archive/refs/tags/lgt3720stable.tar.gz"
  version "3.72.0"
  sha256 "f0fb7ec3b772da5484390d5af8abdd96385f723c653dc9bf0f6dba97574260d3"
  license "Apache-2.0"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "697699fe517eb8223e303a61ce87a9e05843c0e6046cfe2944cbe15632541efb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "697699fe517eb8223e303a61ce87a9e05843c0e6046cfe2944cbe15632541efb"
    sha256 cellar: :any_skip_relocation, sonoma:         "37439c336c1f6c41560561ccac2ef240c491aaad4f6226c079c033075c5308d7"
    sha256 cellar: :any_skip_relocation, ventura:        "be6229831f0469f9e15f9d1593e799b528f5d3dce6c332b2f25fb90405acfbc8"
    sha256 cellar: :any_skip_relocation, monterey:       "37a53e03a23a492fc64aa87c6c5b3fd2eac0b26fe6e32ffba06ac70698de0846"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a744b078dda32ed74ae01f8e90a371d35f51bc44464d595dc08129dd488528fd"
  end

  depends_on "gnu-prolog"

  def install
    cd("scripts") { system "./install.sh", "-p", prefix }
  end
end