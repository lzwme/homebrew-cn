class Ko < Formula
  desc "Build and deploy Go applications on Kubernetes"
  homepage "https:ko.build"
  url "https:github.comko-buildkoarchiverefstagsv0.15.3.tar.gz"
  sha256 "a08956140acca15f37f3eda29391c889ceb1e09558149d23828f06998500628b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b89cbaa198a49eaecca9dd27c7d8a2738f0fe8bf18a5d55efc6c61001daaaf5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b9e2500d68faa27f0b8749c899041fe0d1f09b58219499b61ad6acb607c57a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "afb539b0908582df535a0b3454aeaae1a2dcab9cc66b89ce9749a7827d3f30a1"
    sha256 cellar: :any_skip_relocation, sonoma:         "f5de1991c7f818dd22e2944974152b7fb733affae9f5d6b21c1425579ef45559"
    sha256 cellar: :any_skip_relocation, ventura:        "29d2ae10e00e0ad44415506970429f9c4d6a96a98dab3195b5340dfc4f2f85c8"
    sha256 cellar: :any_skip_relocation, monterey:       "1ffbcc6acbb787c76ed012306cd848905c287dbd64bc744501788b97024a601f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fbc0a97632c1821376a1210caf3785bcca050e3a7e52c5b76fef6e6d9469f0e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.comgooglekopkgcommands.Version=#{version}")

    generate_completions_from_executable(bin"ko", "completion")
  end

  test do
    output = shell_output("#{bin}ko login reg.example.com -u brew -p test 2>&1")
    assert_match "logged in via #{testpath}.dockerconfig.json", output
  end
end