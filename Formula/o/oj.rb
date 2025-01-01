class Oj < Formula
  desc "JSON parser and visualization tool"
  homepage "https:github.comohler55ojg"
  url "https:github.comohler55ojgarchiverefstagsv1.26.0.tar.gz"
  sha256 "50c78bf0bd21924514967bc6039535b3e55db74a7214e7519f52e191db77e2dd"
  license "MIT"
  head "https:github.comohler55ojg.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1ff9beb95f2908004cb96fcc5e24f5ceddc4ed3e1274c15dd816bfc0680922ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ff9beb95f2908004cb96fcc5e24f5ceddc4ed3e1274c15dd816bfc0680922ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1ff9beb95f2908004cb96fcc5e24f5ceddc4ed3e1274c15dd816bfc0680922ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "e402fed7003db67ea73a383cc106b603c6829c7681d49e7db8be98825d4a300a"
    sha256 cellar: :any_skip_relocation, ventura:       "e402fed7003db67ea73a383cc106b603c6829c7681d49e7db8be98825d4a300a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b081c07e45f7b4c4d7549939f3aeb0172e99976572e7d22e50419951478752da"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=v#{version}"), ".cmdoj"
  end

  test do
    assert_equal "1\n", pipe_output("#{bin}oj -z @.x", "{x:1,y:2}")
  end
end