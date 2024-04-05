class Ghq < Formula
  desc "Remote repository management made easy"
  homepage "https:github.comx-motemenghq"
  url "https:github.comx-motemenghq.git",
      tag:      "v1.6.0",
      revision: "7e1195706238d5adf706aa3db6aea883c35cbeda"
  license "MIT"
  head "https:github.comx-motemenghq.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1a812920d6f0920696d47f1b0d9aa0080f545e66896dc19ed987ff25f55abfe3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44f3fb0e53e60a79156198889578ca0d1a13c8f36e626be6c5b35fab10136f6b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f85f890b28daabda04eb3afca3021df5e19e6daf1f678914411652119aca32c"
    sha256 cellar: :any_skip_relocation, sonoma:         "b3fceb1dfd7fe1b2794b49bd0a04d54a0dab5c1372b26e82ba6c32a80dfc22aa"
    sha256 cellar: :any_skip_relocation, ventura:        "941c326dbb45820befb77fb562c57b4fb936c70f9cedea9ef049d9ea76003227"
    sha256 cellar: :any_skip_relocation, monterey:       "0a52355612576470ab4c2e5ef4562eb51c7511f20ecd64d61ac6992256c58a2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5be65a26793875a3cb35a7d8f0037af6775ab032d7b4d0b0ddd987ad5dcd0d21"
  end

  depends_on "go" => :build

  def install
    system "make", "build", "VERBOSE=1"
    bin.install "ghq"
    bash_completion.install "miscbash_ghq" => "ghq"
    zsh_completion.install "misczsh_ghq"
  end

  test do
    assert_match "#{testpath}ghq", shell_output("#{bin}ghq root")
  end
end