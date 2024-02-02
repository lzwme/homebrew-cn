class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https:phrase.com"
  url "https:github.comphrasephrase-cliarchiverefstags2.21.1.tar.gz"
  sha256 "b54f904ac8e29fa3394ff3dbd4b037a9a6711c5a22ac3cb4134deb95ae34383d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2cfc0943140cbc3c0b1ee89ae56a501c84b9b8562683f8694a49f95a32b00f78"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6dfafeece4aac8dfde61b2b37500da14d3bd6712a8584e9efdff8d6d598c0c11"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9d66f171c9fc097c259f1c919a4215537a033c9acbab8c4fbb3131c3d947568"
    sha256 cellar: :any_skip_relocation, sonoma:         "43b2b39c43e3ee09545b1aad10590e052434178ff86101c7c0bfe95d30a23acc"
    sha256 cellar: :any_skip_relocation, ventura:        "9c55127e924673f884f1860afc2811fb6cbb386b6cc474048e290aef9b405b1c"
    sha256 cellar: :any_skip_relocation, monterey:       "8d7bb7ec7bb2597c3cdbeb0c5d13c4f19bb993b6629585227ccdc263e8722759"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c5279fa0679e553aca35cc53023f7309be95df765324108359f33b9c90ce4e3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comphrasephrase-clicmd.PHRASE_CLIENT_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    bin.install_symlink "phrase-cli" => "phrase"

    generate_completions_from_executable(bin"phrase", "completion", base_name: "phrase", shells: [:bash])
  end

  test do
    assert_match "ERROR: no targets for download specified", shell_output("#{bin}phrase pull 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}phrase version")
  end
end