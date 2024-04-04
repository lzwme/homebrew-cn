class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https:skaffold.dev"
  url "https:github.comGoogleContainerToolsskaffold.git",
      tag:      "v2.11.0",
      revision: "5431c6bcbcca066347c0de2dfafca9ff143cd88b"
  license "Apache-2.0"
  head "https:github.comGoogleContainerToolsskaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b1b5373102a16b5c0cb8509c072d15ddc783fd2982c1f7295f9b3897407b66df"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7fd4d08b50d50e80b7cbbfd82c114062ced0e0246dfa9b6fd90a8d6ac7e9e414"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0af818572241ffdcf16f566051ff24904794e6f83c78ece49c168e296bcf463"
    sha256 cellar: :any_skip_relocation, sonoma:         "83bda1a84c0f8d778e82505249f19dfdd3863f02e970679e2f734bf4a9bf163a"
    sha256 cellar: :any_skip_relocation, ventura:        "fadebf459ff0d2d4f147e2dddb450093d14a93031c822a3a2bd256a0fcaab65e"
    sha256 cellar: :any_skip_relocation, monterey:       "873e7d9467e94ec9dbe8ab384e5c3dc863ea7e0a9b310ce086e17a90980a86c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bcb3459804b5a1672ae24880fac87723e08fc52cd76d778350f160c6e9c64bf"
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "outskaffold"
    generate_completions_from_executable(bin"skaffold", "completion")
  end

  test do
    (testpath"Dockerfile").write "FROM scratch"
    output = shell_output("#{bin}skaffold init --analyze").chomp
    assert_equal '{"builders":[{"name":"Docker","payload":{"path":"Dockerfile"}}]}', output
  end
end