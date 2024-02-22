class Stencil < Formula
  desc "Smart templating engine for service development"
  homepage "https:engineering.outreach.iostencil"
  url "https:github.comgetoutreachstencilarchiverefstagsv1.37.3.tar.gz"
  sha256 "682cebdb90a7d319b84513ff8f1384addd9d5855c556c1004c8e3581b610d85c"
  license "Apache-2.0"
  head "https:github.comgetoutreachstencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3f1d208bade856059ccd97507b946d3427dc065fbda84690ba96604f806c40be"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f596ae26b2e4f51e5d0f285e1959e40b08d01d525aa312de9b59394e84432446"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44cfe52418e61908f009d32fe727b6f357ff2acc3adbe56c60111d78b0aa3541"
    sha256 cellar: :any_skip_relocation, sonoma:         "75d60818cd95462a8ee47c722d01dec2ba863f6fab39c737b25d3bdbaca2a1e9"
    sha256 cellar: :any_skip_relocation, ventura:        "8141d0a3b6029030488e0a4cc5108fd6a634b4a2568c3668797156b59c1c18e8"
    sha256 cellar: :any_skip_relocation, monterey:       "49155204c49240a5a3640236e861550f7c2a7e996a21c78b422f79d15139a076"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f091c1099be2dccc8e5296b49203f6d784ab50129424821b24d90525af76dbab"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.comgetoutreachgoboxpkgapp.Version=v#{version} -X github.comgetoutreachgoboxpkgupdaterDisabled=true"),
      ".cmdstencil"
  end

  test do
    (testpath"service.yaml").write "name: test"
    system bin"stencil"
    assert_predicate testpath"stencil.lock", :exist?
  end
end