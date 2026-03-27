class Skaffold < Formula
  desc "Easy and Repeatable Kubernetes Development"
  homepage "https://skaffold.dev/"
  url "https://github.com/GoogleContainerTools/skaffold.git",
      tag:      "v2.18.2",
      revision: "5a5ac63055798309350c4f129387081627013230"
  license "Apache-2.0"
  head "https://github.com/GoogleContainerTools/skaffold.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60c8639723c02cbf79b1d094b30ffe5aabf81ab84f40ce7c48cec86f333130e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "774706ec623ae891b51520c6a7f041b9489adba0b1937ac3138b0983f74741f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce12c48c203ada5d6d6ba06546cac464df786d7a3bc39c54d709a35303e561ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "09c3a513ac0cd3c46598162dace286e13ef0bb830a4ff0f33fc06ee47caa1d85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0556ad470a8cbc86ac648325be8641021c1b49f08ba305cb58fd07bee5e2a7e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b99f37d7db73170428a83120ac6bc95e0d58e90048f3e7a11f79313ba83da357"
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "out/skaffold"
    generate_completions_from_executable(bin/"skaffold", "completion")
  end

  test do
    (testpath/"Dockerfile").write "FROM scratch"
    output = shell_output("#{bin}/skaffold init --analyze").chomp
    assert_equal '{"builders":[{"name":"Docker","payload":{"path":"Dockerfile"}}]}', output
  end
end