class Codesnap < Formula
  desc "Generates code snapshots in various formats"
  homepage "https:github.commistrickyCodeSnap"
  url "https:github.commistrickyCodeSnaparchiverefstagsv0.10.1.tar.gz"
  sha256 "df25de3eb35c597c9de5f6e7bff1b9dceaca660f456f484e7ff4536ba3a62fb1"
  license "MIT"
  head "https:github.commistrickyCodeSnap.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a553c3486e3301d016f8434eef2668c3d6f57c65657f8bc1fb8a4820b95b7565"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "da7a4f8c3f8b1b6a560a14cbf7ef1e36c22349237fd7bb6b13b9ad586353cb6a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "abb10267bf4aec39d5e31cf46ee7cb8381ea69ead67f2957dac58bfce40ccb28"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd90fdc0df376687700e070e9c252bfcf67631f08c33e5f057166b1743ee71da"
    sha256 cellar: :any_skip_relocation, ventura:       "5183b945969dc61342854b13b668630327ef23bdc79841b6045124d1299509c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f9130270486130b3eee8ed12ef82da2364763b71940375fb54402f67c0cb113"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")

    pkgshare.install "examples"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}codesnap --version")

    # Fails in Linux CI with "no default font found"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "SUCCESS", shell_output("#{bin}codesnap -f #{pkgshare}examplescli.sh -o cli.png")
  end
end