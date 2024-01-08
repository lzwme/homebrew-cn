class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https:github.comcargo-binscargo-binstall"
  url "https:github.comcargo-binscargo-binstallarchiverefstagsv1.5.0.tar.gz"
  sha256 "9fb26af3195f9bcf0fab30c55405d6c097390a9ffac377406650078c04af6b34"
  license "GPL-3.0-only"
  head "https:github.comcargo-binscargo-binstall.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "022cc09566377f80fe5b86b7f6f3c2fc24d55b46773d1b8bf013cd4cf251c3a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "270bca78b71f18227cd15aaad3a8ae9f2814e11b8c9ee72a9fc8cc56655cc60c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ff332622c162045aaa8ff948f35c19667589a45e026e0340cb292718ad0b0b6"
    sha256 cellar: :any_skip_relocation, sonoma:         "8a1f63a2bcbe9dac886bbe99af48adb4a06e77725378a09cdc60a905402370c2"
    sha256 cellar: :any_skip_relocation, ventura:        "55af330374684a9133baad94bfc7f11f66cca1750131776e5618d61a1508f620"
    sha256 cellar: :any_skip_relocation, monterey:       "e3cfd4d276cdf2e18acbcc2b2b3f87130aac0ee9bc40f90d46eaf57773c0cde4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85a85ceb8f5d680b800dd84ee48fbbeff29429712c8a979e5f48b81c4ee44fb3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratesbin")
  end

  test do
    output = shell_output("#{bin}cargo-binstall --dry-run radio-sx128x")
    assert_match "resolve: Resolving package: 'radio-sx128x'", output

    assert_equal version.to_s, shell_output("#{bin}cargo-binstall -V").chomp
  end
end