class Gabo < Formula
  desc "Generates GitHub Actions boilerplate"
  homepage "https:github.comashishbgabo"
  url "https:github.comashishbgaboarchiverefstagsv1.3.0.tar.gz"
  sha256 "1afdb7e512996a80145282b044ce386d310ed9799158fd4a30344320c55c97c6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42dafddcb9b6cc42583f454e7dbcb5fcf6f4e692524135c56f8daebfdf0ae461"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "42dafddcb9b6cc42583f454e7dbcb5fcf6f4e692524135c56f8daebfdf0ae461"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "42dafddcb9b6cc42583f454e7dbcb5fcf6f4e692524135c56f8daebfdf0ae461"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e326953053b63a157c17587571834c7bb0ab4004d0c1887666a8a3ba5566e4d"
    sha256 cellar: :any_skip_relocation, ventura:       "6e326953053b63a157c17587571834c7bb0ab4004d0c1887666a8a3ba5566e4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49c097a712532e105c3f58b29f0413bae6831a0b915589f0afd623d5a2da1110"
  end

  depends_on "go" => :build

  def install
    cd "srcgabo" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdgabo"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}gabo --version")

    gabo_test = testpath"gabo-test"
    gabo_test.mkpath
    (gabo_test".git").mkpath # Emulate git
    system bin"gabo", "-dir", gabo_test, "-for", "lint-yaml", "-mode=generate"
    assert_predicate gabo_test".githubworkflowslint-yaml.yaml", :exist?
  end
end