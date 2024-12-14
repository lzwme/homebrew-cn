class Usage < Formula
  desc "Tool for working with usage-spec CLIs"
  homepage "https:usage.jdx.dev"
  url "https:github.comjdxusagearchiverefstagsv1.5.3.tar.gz"
  sha256 "0b4c0d8287cd3c939a399023fe69c1e2f6a3eef4eeb78ec2837f946296cbbf69"
  license "MIT"
  head "https:github.comjdxusage.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea203bd4f431d7de3235bd9bddd2e730db50c95207e11106f3de066cb4c7734b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b7dafdbd63c1f6eb2399c86d0beae194ac2b1eb5328fb6ea959c7c47e98c0726"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5b895149e83e6c5e521b9b13ff3ebeab7095b4aed913d908839214045c414031"
    sha256 cellar: :any_skip_relocation, sonoma:        "af57de1a161d87e4fe45c8948af50cd671646cf495563fd573467d04a696ed0b"
    sha256 cellar: :any_skip_relocation, ventura:       "d7d2cf6ff94e12613e9482c5e284ea0d6c6bcedb2aac19d9acda02390ed3ac16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcec6f51ab9f418ad8b5205cfa26fb92f95c51ddb35b8562e87f0329722105f4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    assert_match "usage-cli", shell_output(bin"usage --version").chomp
    assert_equal "--foo", shell_output(bin"usage complete-word --spec 'flag \"--foo\"' -").chomp
  end
end