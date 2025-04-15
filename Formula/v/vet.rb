class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https:github.comsafedepvet"
  url "https:github.comsafedepvetarchiverefstagsv1.10.0.tar.gz"
  sha256 "3a2e964cb022399317d7e7f20ea6b93b4d6876929ce8a0664a955f3ce8664073"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2e618780f7dee7404ce857bcc6c7c7c463bff079adfe15308896c424786ebf5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "35e10bff7b8f57cf185361992415b3f32658354b521d4e991204c0e925f48a18"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4087677eaae618c12656501804442cfdca1203da960e5444296a69e1e0e2a0f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb4902185d506b4a6e4a523ba35a92226714c5c1323a58400c89d19039ad421d"
    sha256 cellar: :any_skip_relocation, ventura:       "8fda1f873fa826c5c834a94c0e0acb35b95a8327aed7118c27d79f444c4d149a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66a765ec5a25dcab74ae3a9fa8572dd142496f1bb8094a164f2aac62fa27d470"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66ca6302eda4edd428c551ebe41faafc8a319516a62b964d9d2bf76cd7e9903c"
  end

  depends_on "go"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"vet", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}vet version 2>&1")

    output = shell_output("#{bin}vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end