class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https:github.combudimanjojotalhelper"
  url "https:github.combudimanjojotalhelperarchiverefstagsv2.0.0.tar.gz"
  sha256 "91b6ddceff5b58d1595b0095bdf58be846f4f45dc7a369845809992a62a653fd"
  license "BSD-3-Clause"
  head "https:github.combudimanjojotalhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2344cb69d75519bc478656097e8efc7a429c233a2a31aa10c95a2a9fa78ecc73"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6815669ec45af35066040ff577125e379242d533226450c8c4ca7dd9e82c8f5c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba690f49d675d7a62d16511a85c15a997bc0f727cc8aa4a1ed598dad2896aff5"
    sha256 cellar: :any_skip_relocation, sonoma:         "3e1018a7bb0f6c79bf53d0dffcbfff09e3224b8efdb0a4eafede4e011a346bb3"
    sha256 cellar: :any_skip_relocation, ventura:        "88e7ab45340e9b93199112e1953d9bed3085ac9e8a64d9718c420a4f5291640c"
    sha256 cellar: :any_skip_relocation, monterey:       "eb4ca1a8494ab636660cc55fdf01788d7b5ddbcf50da498a3e07511f7b6fcc4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5b58686c3511a7224b5251911ad79587581dd2e96b1a1d5bcc9e75db7a68b65"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.combudimanjojotalhelpercmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

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