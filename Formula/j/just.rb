class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https:github.comcaseyjust"
  url "https:github.comcaseyjustarchiverefstags1.24.0.tar.gz"
  sha256 "28409df27f73232ccb3e1671e9ee7354a954ecf3a28f64a52b1f3d213c3a5bd5"
  license "CC0-1.0"
  head "https:github.comcaseyjust.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9092c6023bc9cd3062ce373b1e6d60e44f3ec2bb8effe2588275a5465c6b66db"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5008ce69bc7ed78d3871fb93635fa6b4d13c00fed08ba5f22fccfaa2702871ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a798a8053f4e80aad972d502cc199386dd955ce63e0eed34648204068e40bbb9"
    sha256 cellar: :any_skip_relocation, sonoma:         "a9f2f8e4e4818b67f4a22b9724d0e6b14700bd810cb2dd071a612bb97ee263f4"
    sha256 cellar: :any_skip_relocation, ventura:        "1d2e60914fa9f972a21482b70985b04326d8cdeb2a96e1a138b5ecc88d9be54d"
    sha256 cellar: :any_skip_relocation, monterey:       "1faf0b5181b5260748526357416781b8c0741f7ff554addf3b453c93eb11415d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf42f134d557ce54cd6fa83d867c0e330ad1be6c1ab2f9a5482ba552bf26bbe0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    man1.install "manjust.1"
    bash_completion.install "completionsjust.bash" => "just"
    fish_completion.install "completionsjust.fish"
    zsh_completion.install "completionsjust.zsh" => "_just"
  end

  test do
    (testpath"justfile").write <<~EOS
      default:
        touch it-worked
    EOS
    system bin"just"
    assert_predicate testpath"it-worked", :exist?
  end
end