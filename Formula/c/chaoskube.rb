class Chaoskube < Formula
  desc "Periodically kills random pods in your Kubernetes cluster"
  homepage "https:github.comlinkichaoskube"
  url "https:github.comlinkichaoskubearchiverefstagsv0.30.0.tar.gz"
  sha256 "5fa2205cf83880afda3af67b19a29909db1a27c90212abde5cdfd2acba32202a"
  license "MIT"
  head "https:github.comlinkichaoskube.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3b648643a910910469aff65441fd6f4aa81748cc20ec4263116c56e5fdba9fe5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a61eb249ff6f6cfd31fdcb5da119a307959bf1323cd7ee65f770c9fc3d0b0c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d1d65da2ed4e9800bcf0da8a45d76dc4b7e0003939dce3b3f4605addb1568bf"
    sha256 cellar: :any_skip_relocation, sonoma:         "cc290e25ab9f30df2ab2f5c016b38de0c1251a50a5e3fbfa1f2db13bec0246e2"
    sha256 cellar: :any_skip_relocation, ventura:        "8408b3c1e736e9bff280f55fcf3e837eaac07f16c0e73fce5eed568e8ce6627a"
    sha256 cellar: :any_skip_relocation, monterey:       "d2bfa779d7774c52a7ad144610e32d3aca065cd61ebf7b1381144f10a5c92998"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f15597411e7f2cb333bc02c9c98a95d5402b46c76d21d03d049203bc31574f74"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    output = shell_output("#{bin}chaoskube --labels 'env!=prod' 2>&1", 1)
    assert_match "dryRun=true interval=10m0s maxRuntime=-1s", output
    assert_match "Neither --kubeconfig nor --master was specified.  Using the inClusterConfig.", output

    assert_match version.to_s, shell_output("#{bin}chaoskube --version 2>&1")
  end
end