class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https:k8sgpt.ai"
  url "https:github.comk8sgpt-aik8sgptarchiverefstagsv0.4.8.tar.gz"
  sha256 "5214def88d24adb422e609d49bd6d83bfae5849b2c6b3e6a78d410ea8d99375b"
  license "Apache-2.0"
  head "https:github.comk8sgpt-aik8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a8acb3c4a4a1b4ed69157f2cad8d3f8bfb0359da5652eb5fb37d77ef7c74b8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4701d8d79ed214b8325d61e0082448940169f01ef315ef3611b223b8ea483eca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4f3d75342942beab2de7d9c26204384877c8f0d77235310cf824203e5efa8585"
    sha256 cellar: :any_skip_relocation, sonoma:        "058bfcc360b8e8172f80af97190d6b3526cbec8b576ae6f8f724493bcb59cf35"
    sha256 cellar: :any_skip_relocation, ventura:       "dbdfa4eb668edf77040f8170c57532bac933ff76e50b477a853abb7b9b9edffe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "924be6d75196b8b32e61b7cde22f67414eb488b1e408a4986f2aa98a2fb99a46"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"k8sgpt", "completion")
  end

  test do
    output = shell_output("#{bin}k8sgpt analyze --explain --filter=Service", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output

    assert_match version.to_s, shell_output("#{bin}k8sgpt version")
  end
end