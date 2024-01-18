class Draco < Formula
  desc "3D geometric mesh and point cloud compression library"
  homepage "https:google.github.iodraco"
  url "https:github.comgoogledracoarchiverefstags1.5.7.tar.gz"
  sha256 "bf6b105b79223eab2b86795363dfe5e5356050006a96521477973aba8f036fe1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1f4fe7b05ef229486843e184c0697489dbb3e989d1445000639a203ab46f6930"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3af268ae6b1611e6110f380caebb21c017909d63aa9d1fb06432410159038763"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52eb3ca3d3ec7aa77a70d4b985096409ed2a4c17d27718426a43bf1c9427435b"
    sha256 cellar: :any_skip_relocation, sonoma:         "814aaa444d53214093d915e256f8a7ccc6677c59503e1ce706774ce567614976"
    sha256 cellar: :any_skip_relocation, ventura:        "e2b2177c30a62da96b47b4e0f433f279af482477561508e6637fa800e8b90add"
    sha256 cellar: :any_skip_relocation, monterey:       "e16ac56c7b5906c79b9c501ce9b17169a621156911613ccbb5f257809764b11d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f36b1685009883d27bf08cd3d554ecb16c05fe25b127cedc9980f20d6897f654"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", * std_cmake_args
      system "make", "install"
    end
    pkgshare.install "testdatacube_att.ply"
  end

  test do
    system "#{bin}draco_encoder", "-i", "#{pkgshare}cube_att.ply",
           "-o", "cube_att.drc"
    assert_predicate testpath"cube_att.drc", :exist?
  end
end