class Bup < Formula
  desc "Backup tool"
  homepage "https:bup.github.io"
  url "https:github.combupbuparchiverefstags0.33.6.tar.gz"
  sha256 "62108488f8d1027ac63f276e28f749129055628a82d23f4b926e10deb93cb54f"
  license all_of: ["BSD-2-Clause", "LGPL-2.0-only"]
  head "https:github.combupbup.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "df8271018cddc10787297ae3ac38e8edda355a7227471e9ef119c663267c7345"
    sha256 cellar: :any,                 arm64_sonoma:  "e126ea3ee137ff6c99fecf0f8ffc8563fd3530f7e02f6c3fe198e03210d7c160"
    sha256 cellar: :any,                 arm64_ventura: "012e7917175154e0f74d851a34a7c22f1ce9b0035dfbb7e645e7336a059d8504"
    sha256 cellar: :any,                 sonoma:        "f8b3bad61c33f8d778e3b554a8d591f133f3d84ef7bef9155299964ce48edd91"
    sha256 cellar: :any,                 ventura:       "ac8fca2732f37bc3ff0beae4753dba78f33fc35790261eb54d0b0b8fbfef9527"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a9634bdbabeb6734ec49252baea50b710c09d807de83b3721ebf79fdf6d7c3f"
  end

  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build

  depends_on "python@3.13"
  depends_on "readline"

  on_linux do
    depends_on "acl"
  end

  def python3
    which("python3.13")
  end

  def install
    ENV["BUP_PYTHON_CONFIG"] = "#{python3}-config"

    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin"bup", "init"
    assert_predicate testpath".bup", :exist?
  end
end