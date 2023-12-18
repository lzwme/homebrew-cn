class Govc < Formula
  desc "Command-line tool for VMware vSphere"
  homepage "https:github.comvmwaregovmomitreemastergovc"
  url "https:github.comvmwaregovmomiarchiverefstagsv0.34.0.tar.gz"
  sha256 "fc6f6db5e38a3fdf304bcf89ae6f576234f9b38d196da17d4f1836e02362e183"
  license "Apache-2.0"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "19535c1bfc569646ddd0476f4d25c1384d91a039d78564629187fa75ee05d8dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a0b689ba4504c7ae1b9ad29405be28d20220dc32a056e9ed0d20c88e79eb3b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b0a500ca3572fb3f05e044d568920af703701b1903c8c77ff5101544ef406f8"
    sha256 cellar: :any_skip_relocation, sonoma:         "47c2a2f492382dbc21456606f9dece2b59c15252b16ac6e28a108215df28d406"
    sha256 cellar: :any_skip_relocation, ventura:        "fad3baf48966182e4f8f0d3bc9f8c5cdc7caf00d9a2cd593ed489269e973f099"
    sha256 cellar: :any_skip_relocation, monterey:       "bf6124e2ef750a5129b3312213cca90129b69aba8fb33771289d94f1387c0573"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1889c4b3a91b620dc462e58ce1d54de6f90cc5b53267b7ee3ba401432b51a8f9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "#{bin}#{name}", ".#{name}"
  end

  test do
    assert_match "GOVC_URL=foo", shell_output("#{bin}#{name} env -u=foo")
  end
end