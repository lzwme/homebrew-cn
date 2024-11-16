class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https:github.comvmwaregovmomitreemastergovc"
  url "https:github.comvmwaregovmomiarchiverefstagsv0.46.1.tar.gz"
  sha256 "bccd949c843313472919e52ac63f7e1d1a2a713e6dbd007d19916dcc6335afb4"
  license "Apache-2.0"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ede4af03b976732d6f70caaf3e8ad30ac09aae2ea04c8e45c18227e057e1d815"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84e84c6243cfbf6559052747501402627357fd495debf74d1ff8d2948192a2ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c606dcf54c8229e2dee90cf07594fd0063771f7043c1d037502583ef28ef868b"
    sha256 cellar: :any_skip_relocation, sonoma:        "b75177c28dde552b41ec1f6ee7846960449021055dd8f60b570ec6c3e701668b"
    sha256 cellar: :any_skip_relocation, ventura:       "b258a775daee9041f8e5fb4332e0c190792c9d9a0107315a1e4c725cef1dc80a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7cea89cd706b0da436c400549bf7c99d70e251a17fcb413b7b6ab3b32093b24"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}#{name}", ".#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}#{name} env -u=foo")
  end
end