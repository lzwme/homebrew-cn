class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https:skaffold.dev"
  url "https:github.comGoogleContainerToolsskaffold.git",
      tag:      "v2.10.0",
      revision: "cbc665bfc1fe7253df466e70dd48e3851d935a3e"
  license "Apache-2.0"
  head "https:github.comGoogleContainerToolsskaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "651b9efb3d1935eb6b217c91f8e72249daff52cf2ce08d1cac767255a4ded1df"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "18cf224767039c8f686e5510c91a48d8e3669017c8351ea5d8f9dcb118b4fcbd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8eb64353218c52883223cec4d8a2f9b92059d0038c6371d13c0416308239888d"
    sha256 cellar: :any_skip_relocation, sonoma:         "78b9be46c628b1f29b65c4c20273ae1817434d1b6f389e0d94781c5ce29330be"
    sha256 cellar: :any_skip_relocation, ventura:        "4e9cc4ebfe665199f4a746809ccf8a3a2c7ada705948f146b355c6d2e827bd0b"
    sha256 cellar: :any_skip_relocation, monterey:       "7ff9e7639a4e38755cf55fb6e1e0addbf8a2ddd3ee86d40c3090d2d5d62fd7ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60b321a0450f3e14df3c807af383a289d417b0c23d5a3bd60f2cc6d7ca232399"
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