class Chamber < Formula
  desc "CLI for managing secrets through AWS SSM Parameter Store"
  homepage "https:github.comsegmentiochamber"
  url "https:github.comsegmentiochamberarchiverefstagsv2.14.0.tar.gz"
  sha256 "415d967a77f31ac514423c9b8e6ce44c3fdff2afa208c6c2231e1b894fea6194"
  license "MIT"
  head "https:github.comsegmentiochamber.git", branch: "master"

  livecheck do
    url :stable
    regex(v?(\d+(?:\.\d+)+(?:-ci\d)?)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2c2359131113966386ae1805015f18332b9a3b5ad0fc81839467a01165fc2715"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "755b1a570d268bc36336c82c4e01409cfb4967131513cd9404693cd14025105f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d4ea9b43778358ea652787c4e339983a31f852ae0f8c9ea37ec96b21844452d"
    sha256 cellar: :any_skip_relocation, sonoma:         "3703272614404d2ae884b8706a89637dbfc106bc91910343fb45119e09953ab6"
    sha256 cellar: :any_skip_relocation, ventura:        "488fd9f50e240e8810a97d857514a572d6f1e897b4725081b5f88317b625c761"
    sha256 cellar: :any_skip_relocation, monterey:       "4181235831174666d5cf57d9b7f5ba593c6c776b04000fb5fad379d348343e33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abaa8c7f37e235bce95e89941a267b66cb7fcea242d40d5b1d4e2fa5d7cb5313"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=v#{version}")
    generate_completions_from_executable(bin"chamber", "completion")
  end

  test do
    ENV.delete "AWS_REGION"
    output = shell_output("#{bin}chamber list service 2>&1", 1)
    assert_match "MissingRegion", output

    ENV["AWS_REGION"] = "us-west-2"
    output = shell_output("#{bin}chamber list service 2>&1", 1)
    assert_match "NoCredentialProviders", output
  end
end