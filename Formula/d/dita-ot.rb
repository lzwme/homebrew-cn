class DitaOt < Formula
  desc "DITA Open Toolkit is an implementation of the OASIS DITA specification"
  homepage "https:www.dita-ot.org"
  url "https:github.comdita-otdita-otreleasesdownload4.2.1dita-ot-4.2.1.zip"
  sha256 "85f6acb73d4cfddf43ed05a7e3cbf6a9b18a69d5820d373103be28dcd2e4cc9a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cc3de21e6f8991f9dfb945f9e5a902c6c00dd81311840d9296ac4ea5a18982c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc3de21e6f8991f9dfb945f9e5a902c6c00dd81311840d9296ac4ea5a18982c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc3de21e6f8991f9dfb945f9e5a902c6c00dd81311840d9296ac4ea5a18982c0"
    sha256 cellar: :any_skip_relocation, sonoma:         "2bf26835a4804350c2e1b125c712e882978ea01c3c2d2b7186f910514ef4454e"
    sha256 cellar: :any_skip_relocation, ventura:        "2bf26835a4804350c2e1b125c712e882978ea01c3c2d2b7186f910514ef4454e"
    sha256 cellar: :any_skip_relocation, monterey:       "2bf26835a4804350c2e1b125c712e882978ea01c3c2d2b7186f910514ef4454e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18ec93e3cb371f17a3331a4d133dbe0ee6241c96dd6fb6a22cba50f3fee3cdf3"
  end

  depends_on "openjdk"

  def install
    rm_f Dir["bin*.bat", "configenv.bat", "startcmd.*"]
    libexec.install Dir["*"]
    (bin"dita").write_env_script libexec"bindita", JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  test do
    system bin"dita", "--input=#{libexec}docsrcsite.ditamap",
           "--format=html5", "--output=#{testpath}out"
    assert_predicate testpath"outindex.html", :exist?
  end
end