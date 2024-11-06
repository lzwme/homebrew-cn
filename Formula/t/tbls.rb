class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https:github.comk1LoWtbls"
  url "https:github.comk1LoWtblsarchiverefstagsv1.79.1.tar.gz"
  sha256 "cc42e68e5c3127cf070de36c558a1ad164914def90a3469b76096d12c9d00f12"
  license "MIT"
  head "https:github.comk1LoWtbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94c1e3b26702d287e8e9b7cccc15e0acfa3033a0fa69c21e47c19e275fa2f4e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ddd69cc86aa24d97db0b3523fa02f3d6098bce28e321a86c54abb09396770542"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "64dd3e7a760dad5448bbbf4a8e645ea8d1e17b561130328a104bcb7dffc97d5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a6ff162c25d350b99a8c9304759230e42ca775cc5d80731392efe298e78c0fe"
    sha256 cellar: :any_skip_relocation, ventura:       "2b67e4046fda9d7bff7f6fb22856155152e54034ee3d61ba1ae36ecfcb359293"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45664b11aca02fb153b6f48a16f6c5e141b4c4172ca50c2dd7093189ed605945"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comk1LoWtbls.version=#{version}
      -X github.comk1LoWtbls.date=#{time.iso8601}
      -X github.comk1LoWtblsversion.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"tbls", "completion")
  end

  test do
    assert_match "invalid database scheme", shell_output(bin"tbls doc", 1)
    assert_match version.to_s, shell_output(bin"tbls version")
  end
end