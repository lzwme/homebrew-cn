class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https:k8sgpt.ai"
  url "https:github.comk8sgpt-aik8sgptarchiverefstagsv0.3.39.tar.gz"
  sha256 "b2a523a4c1b9d6f968388c09c333d0e710ad694d7f840dc7e7eaca90b314ab8b"
  license "Apache-2.0"
  head "https:github.comk8sgpt-aik8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "39da905d2b81e90a7ede1fb056ecbc64993ffa1f9e7a0d0f7513cf3c7577cde3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95d06cad57985f09703c6748d1fe5ee1cc4aaa1f9869aab565155d7e1207d26c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c0978f7c6628f277e5bf17772e20eb4044bf328e780ddd9c5ef9f8f3fd26f19"
    sha256 cellar: :any_skip_relocation, sonoma:         "bbf8638b9e407348b200d045feb8f1f2c78d6e92b3ca82397ee2fab773b5ddf1"
    sha256 cellar: :any_skip_relocation, ventura:        "f293f16e097cbdd7bc579261436646c607c4c1756c873bf56c26c70b13620a40"
    sha256 cellar: :any_skip_relocation, monterey:       "09b370170ad4d8c6ad05747f054e8f358ecff411a61c7b2e1dd68326d4303fea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3d951e870092a8c0f0855be1404c5a5cd0fb30f8d0cc57b80d82014b505ffe1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}k8sgpt analyze --explain --filter=Service", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output

    assert_match version.to_s, shell_output("#{bin}k8sgpt version")
  end
end