class K8sgpt < Formula
  desc "Scanning your k8s clusters, diagnosing, and triaging issues in simple English"
  homepage "https:k8sgpt.ai"
  url "https:github.comk8sgpt-aik8sgptarchiverefstagsv0.3.31.tar.gz"
  sha256 "a76dded5c65c9694fabcc667be361c6961adcc5f12f9f37f665ca2bd08820eeb"
  license "Apache-2.0"
  head "https:github.comk8sgpt-aik8sgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b8043e86eb7d36eb88502b00bd2660cc702cc556f04bda9dcb656d9d1f525202"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a328f6661b1c55c70ce7b127e15a00bd9f23a29c5406126b2ce94b1621adc5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b41a999bd6af05d96708df8e6d6d7d02c94730fcaef2714eb3b4659107f54b48"
    sha256 cellar: :any_skip_relocation, sonoma:         "5d4f13020c147b1ef0e6f9db6607e4b8553b862c4c99d7e7af1a078cbe93d90c"
    sha256 cellar: :any_skip_relocation, ventura:        "e9510b448b45e0979d09b9a91669671ab2214b45b80c882913d7e716479977bb"
    sha256 cellar: :any_skip_relocation, monterey:       "a166520302fa94b62f26840099b39f0cf3d36413d27c3eb6a2520e686f306e50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e9502c6a8a33dd5d147bd35335b7996df8d15b9a79b339a9d7ef14c58ad27ad"
  end

  depends_on "go" => :build

  # patch build, upstream pr ref, https:github.comk8sgpt-aik8sgptpull1115
  patch do
    url "https:github.comk8sgpt-aik8sgptcommit1fb75a633c546bc6ada689e27d29c134d4cf8b5f.patch?full_index=1"
    sha256 "9ca5985449b404e4d12db2c3ce8823a18dc29fa9f8b391eb48c0de22400fe292"
  end

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