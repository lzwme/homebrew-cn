class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https:k9scli.io"
  url "https:github.comderailedk9s.git",
      tag:      "v0.32.6",
      revision: "9984e3f4bfa0b88a4c0ae62cd69b61f80b7ce3c2"
  license "Apache-2.0"
  head "https:github.comderailedk9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66da6ecefdb6249c6d456da1cfbb5a07595bcf5163d0e4369e1fb3bfd3c0e199"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "efc30267b4a8b14122553643de2dbed6be3225605625e2b2bbeabccb6a720cce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f5b6e5a5bdaddfc2f0765dd77c824690475ff7564ac78eec609149b0232a6396"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd82884bcd7b7e05ec49e99c1c8d3d114d27de5bb1b67b8e90b3d80cb6473549"
    sha256 cellar: :any_skip_relocation, ventura:       "e4220e7ad7f3d5b0fc739fea35de7fe303878319694d2d007e43144b3aa6bd43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d7a90a751b8aa946cad0cbb127531dab798a7a253e5e44c5f711d78b74b1573"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comderailedk9scmd.version=#{version}
      -X github.comderailedk9scmd.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"k9s", "completion")
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}k9s --help")
  end
end