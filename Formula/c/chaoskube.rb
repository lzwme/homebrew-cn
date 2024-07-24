class Chaoskube < Formula
  desc "Periodically kills random pods in your Kubernetes cluster"
  homepage "https:github.comlinkichaoskube"
  url "https:github.comlinkichaoskubearchiverefstagsv0.32.1.tar.gz"
  sha256 "9f39f1165f9d325806f0a7847140214d6b607e945c7d374b362390d906a71d42"
  license "MIT"
  head "https:github.comlinkichaoskube.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "daf6ac821de4b91f5cf0c4882bb1b9d81d8be2a154aa5040831a3f618b450fbb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "213fb6e28eb800f0059331e9d5f6f9114e0c4ea3dc9744abf389fc12bad82c85"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dabe2843a3434a1ec8be3360447252e618ad21597162cb3cc145462e278cebf6"
    sha256 cellar: :any_skip_relocation, sonoma:         "28033bbe57f86b12cfbb589bedfdb42fbf94b45921715ec7f47d8349c259fb68"
    sha256 cellar: :any_skip_relocation, ventura:        "454eec9e4d462062b009568af1d15e8e8628596f845d1f787cc86fef8329f251"
    sha256 cellar: :any_skip_relocation, monterey:       "2c3d549339ee82cbcc2ad9932ad3d53002812de5ceaf812a2afc9e3df2f4f0d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cfbf1ed7dbca364cb64ed66aef7a11a9673138ce53250a73745f8b293ecb494"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}chaoskube --labels 'env!=prod' 2>&1", 1)
    assert_match "dryRun=true interval=10m0s maxRuntime=-1s", output
    assert_match "Neither --kubeconfig nor --master was specified.  Using the inClusterConfig.", output

    assert_match version.to_s, shell_output("#{bin}chaoskube --version 2>&1")
  end
end