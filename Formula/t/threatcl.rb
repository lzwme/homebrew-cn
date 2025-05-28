class Threatcl < Formula
  desc "Documenting your Threat Models with HCL"
  homepage "https:github.comthreatclthreatcl"
  url "https:github.comthreatclthreatclarchiverefstagsv0.2.3.tar.gz"
  sha256 "9b0a9917d889de32b645e8c448a2c5dea8d9df53a37db6981466640affcc26a2"
  license "MIT"
  head "https:github.comthreatclthreatcl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2578b6d622b2800b34a2c5faa1ed18a75373936fe9d1437a67d7da0f7f205839"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "693d71c257620270ab997207c334a04deaafcff597cf97749ebc1af6b5a27095"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "32c5a71d567c31472c3a3e961b61f3cca3dff6e8449f9dc50609062008a6d018"
    sha256 cellar: :any_skip_relocation, sonoma:        "adaf705a7fbb5c9645df4db8b60611c2a3f1671b218ce0918e39330896fee269"
    sha256 cellar: :any_skip_relocation, ventura:       "e39b7d190c7fd3670c252f2d09524d4f71611e4d23ceca6e27f6110313e6eb2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1fad1a7947637707363161e43b732b1fa193f0b26520cd6de323163dfd301782"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c29a70a9c59cf2e16130d06caf5ddd3ac9d30848bcf25c60c8a93080e01f8311"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdthreatcl"

    pkgshare.install "examples"
  end

  test do
    cp_r pkgshare"examples", testpath
    system bin"threatcl", "list", "examples"

    output = shell_output("#{bin}threatcl validate #{testpath}examples")
    assert_match "[threatmodel: Modelly model]", output

    assert_match version.to_s, shell_output("#{bin}threatcl --version 2>&1")
  end
end