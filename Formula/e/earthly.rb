class Earthly < Formula
  desc "Build automation tool for the container era"
  homepage "https:earthly.dev"
  url "https:github.comearthlyearthly.git",
      tag:      "v0.8.13",
      revision: "251e0eada58646e71c562b803bc4b9adbcf07637"
  license "MPL-2.0"
  head "https:github.comearthlyearthly.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4d9a09835abf35f8828e187eb22ab3094ad5a71b6a5f5db15d8f761dffafeec1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d9a09835abf35f8828e187eb22ab3094ad5a71b6a5f5db15d8f761dffafeec1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d9a09835abf35f8828e187eb22ab3094ad5a71b6a5f5db15d8f761dffafeec1"
    sha256 cellar: :any_skip_relocation, sonoma:         "7e154ce8e69c1928ac5977a410637137f27aaf8cbbc53a74c05e45fbde3e5a55"
    sha256 cellar: :any_skip_relocation, ventura:        "7e154ce8e69c1928ac5977a410637137f27aaf8cbbc53a74c05e45fbde3e5a55"
    sha256 cellar: :any_skip_relocation, monterey:       "7e154ce8e69c1928ac5977a410637137f27aaf8cbbc53a74c05e45fbde3e5a55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "501e703cac69356f51a179e8eb51f04d9a4d9727b0df7f2fcd50434da707bfd8"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X main.DefaultBuildkitdImage=earthlybuildkitd:v#{version}
      -X main.Version=v#{version}
      -X main.GitSha=#{Utils.git_head}
      -X main.BuiltBy=homebrew
    ]
    tags = "dfrunmount dfrunsecurity dfsecrets dfssh dfrunnetwork dfheredoc forceposix"
    system "go", "build", "-tags", tags, *std_go_args(ldflags:), ".cmdearthly"

    generate_completions_from_executable(bin"earthly", "bootstrap", "--source", shells: [:bash, :zsh])
  end

  test do
    # earthly requires docker to run; therefore doing a complete end-to-end test here is not
    # possible; however the "earthly ls" command is able to run without docker.
    (testpath"Earthfile").write <<~EOS
      VERSION 0.6
      mytesttarget:
      \tRUN echo Homebrew
    EOS
    output = shell_output("#{bin}earthly ls")
    assert_match "+mytesttarget", output
  end
end