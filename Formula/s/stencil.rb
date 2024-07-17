class Stencil < Formula
  desc "Smart templating engine for service development"
  homepage "https:engineering.outreach.iostencil"
  url "https:github.comgetoutreachstencilarchiverefstagsv1.39.0.tar.gz"
  sha256 "d7c173fff239b373c723187b849c18503f8370b0da34fb76ff015bf466485a44"
  license "Apache-2.0"
  head "https:github.comgetoutreachstencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2f72a881e26a881ec0260ed7f329d697c146f770944249f981a54f61c83369c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d17349f59106c934cfb77725058e16170b0acd47e73586603d861e59fe27b354"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e362940cee505014f8b2a348ae265d076b0f7cc392f9fa6518c88521b7c1064"
    sha256 cellar: :any_skip_relocation, sonoma:         "93023de5c6b55122e3dbd883fe79be842b7994675575c8b7773683c13e4f42ba"
    sha256 cellar: :any_skip_relocation, ventura:        "a7e2bf91dc4bce6eb00c8e32c3286288dd200240090abb050fded79c59695778"
    sha256 cellar: :any_skip_relocation, monterey:       "241f20a7dfa64b01997548c6d6197a2c3d7a5592d90c5ed644df9b1481cd3773"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5fc212e84e14a7603d674328150215f00ff851e12620d18e0f0efb1b6eb68a4"
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