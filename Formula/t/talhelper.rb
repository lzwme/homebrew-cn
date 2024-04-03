class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https:budimanjojo.github.iotalhelperlatest"
  url "https:github.combudimanjojotalhelperarchiverefstagsv2.3.10.tar.gz"
  sha256 "fa251cf863376b3800bcd83b6ad63409fbac77bd93594f023df41523bf345dbb"
  license "BSD-3-Clause"
  head "https:github.combudimanjojotalhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e4ac752d8e2d2c0ae2fcc2377d3763818c6b8c67a8b1f7a98f12cc14a216ac75"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "967f68ad7590b381a17685b243842d6d343916e6c64a312170913c88a93a33eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c496002b72fbe55e4e817eb05518a6f6f6c3a985dacfda5e787a1b3dc057263e"
    sha256 cellar: :any_skip_relocation, sonoma:         "8f329d586749db9ed1461e33a17e1f28a2694b2d1c93557ac0a1356dfd19bb66"
    sha256 cellar: :any_skip_relocation, ventura:        "2fe55dfbeea71d48d32b4daa78bf73024b091e5f52ce49ffc95eba17ba4d173b"
    sha256 cellar: :any_skip_relocation, monterey:       "8376a9e4d2ec664c39a68c54fbd9782e403f2090a38aee3ad238114eb8cd6295"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "053408d004486422f85c138caac4f3c0f3aa10f12ac560753f4d12bfbcbf81cb"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.combudimanjojotalhelpercmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"talhelper", "completion")
    pkgshare.install "example"
  end

  test do
    cp_r Dir["#{pkgshare}example*"], testpath

    output = shell_output("#{bin}talhelper genconfig 2>&1", 1)
    assert_match "failed to load env file: trying to decrypt talenv.yaml with sops", output

    assert_match "cluster:", shell_output("#{bin}talhelper gensecret")

    assert_match version.to_s, shell_output("#{bin}talhelper --version")
  end
end