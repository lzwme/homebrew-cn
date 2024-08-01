class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https:github.comanchoregrype"
  url "https:github.comanchoregrypearchiverefstagsv0.79.4.tar.gz"
  sha256 "f3c6d42a8302da5f798dfc49cc334dd7a86e588559bd9c3c1c41eb953939bb3d"
  license "Apache-2.0"
  head "https:github.comanchoregrype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3289ee442bd7b2e75e172afc294efebad182e2e7a036dbe96898dcbd04533b0f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5079d29d0233e543bc8fd050b697bcbb48c73fb870d3a428b2d6be1213466af5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c59d2efaa60942d8518de1093828451ffceba4a097bbd2dc32a84375d3e0489"
    sha256 cellar: :any_skip_relocation, sonoma:         "13430c28530e32c64fabfaef2b12b6ba3306700e5d0e6fa369e0dd229db1109b"
    sha256 cellar: :any_skip_relocation, ventura:        "ab6b63567287f090f5f86a6894eadf86b8547740b8cb39e889e591941ac71f1e"
    sha256 cellar: :any_skip_relocation, monterey:       "9ff37e518abbc2489240509f0a666efd0c6a62cae9d1de7c3127ec963bc3edc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb03a3f674a9f4ba39f0101ef00c99acf6f75ce310e23831511fa8d998cd0f78"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.gitCommit=brew
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), ".cmdgrype"

    generate_completions_from_executable(bin"grype", "completion")
  end

  test do
    assert_match "database metadata not found", shell_output("#{bin}grype db status 2>&1", 1)
    assert_match "Update available", shell_output("#{bin}grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}grype version 2>&1")
  end
end