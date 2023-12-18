class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https:skaffold.dev"
  url "https:github.comGoogleContainerToolsskaffold.git",
      tag:      "v2.9.0",
      revision: "6071a3f7574702c8666a243d89254e9b0d8ff4d7"
  license "Apache-2.0"
  head "https:github.comGoogleContainerToolsskaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2919c33d6a7455444bdf2d7652a2c9f5c159e7fa8b5f39a69e8d189fd4dbddbd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "87265bf4a734d70d129d585cec28b328f209b18d30a6cc23e5194e814aa2568e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e16d6f598de9d8c53928f8d549c42a9067f1232b38f39ea597f90b166561b040"
    sha256 cellar: :any_skip_relocation, sonoma:         "1ccdce85c6a8753def964d357a3aaaec030cbb33c7e5b2bd9c3c2612e4c0dc26"
    sha256 cellar: :any_skip_relocation, ventura:        "5c50fc067004b75f3f6478df2bfb0782d42892c27f8653e9f886498ad094abc4"
    sha256 cellar: :any_skip_relocation, monterey:       "71ff6c0de18717f335f8e96a9346f2369d7a1eeac4e3c599dff6ac2820cfa03d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a3e2ecd26a2099ec9a7767ddd8f547951f1750637755217d6b9aa1ec0a3955e"
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