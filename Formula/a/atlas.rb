class Atlas < Formula
  desc "Database toolkit"
  homepage "https:atlasgo.io"
  # Upstream may not mark patch releases as latest on GitHub; it is fine to ship them.
  # See https:github.comarigaatlasissues1090#issuecomment-1225258408
  url "https:github.comarigaatlasarchiverefstagsv0.28.0.tar.gz"
  sha256 "e93a3e60b7cff098645e0f2c619c5957ab52c2ab7c9bf52fafdc723c7e5ae861"
  license "Apache-2.0"
  head "https:github.comarigaatlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cfa9b6b4e58d3f9a283b9a1bba6a2fd3637000aa71bd04043f844be4303f1120"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d6d49586afa9bf6a913347159b026188de2b179a5c310e2f3ef74b6da5ea8914"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1b1e74b3991e421988a12bf1ee5720264231d9027feb55752dfaba01df0a9739"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3d9578bbf2647e89ee5f6c333a97b3a613f9bc710c0cce7cddc5ada4838fab8"
    sha256 cellar: :any_skip_relocation, ventura:       "815f97b0c0a5f40cbebb3bbce51eae0685f9371d1699f5902f183e98d8e01825"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "93ef6f6bc964cece70a6132b2e659a4e47814e8a79a8e05990e66f5cb1d2b0c8"
  end

  depends_on "go" => :build

  conflicts_with "mongodb-atlas-cli", "nim", because: "both install `atlas` executable"

  def install
    ldflags = %W[
      -s -w
      -X ariga.ioatlascmdatlasinternalcmdapi.version=v#{version}
    ]
    cd ".cmdatlas" do
      system "go", "build", *std_go_args(ldflags:)
    end

    generate_completions_from_executable(bin"atlas", "completion")
  end

  test do
    assert_match "Error: mysql: query system variables:",
      shell_output("#{bin}atlas schema inspect -u \"mysql:user:pass@localhost:3306dbname\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}atlas version")
  end
end