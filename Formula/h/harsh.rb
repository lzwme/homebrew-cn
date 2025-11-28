class Harsh < Formula
  desc "Habit tracking for geeks"
  homepage "https://github.com/wakatara/harsh"
  url "https://ghfast.top/https://github.com/wakatara/harsh/archive/refs/tags/0.12.1.tar.gz"
  sha256 "dc2242cd816e367698825956d15503ee54f8e785c52b7af49725fb548864fbd4"
  license "MIT"
  head "https://github.com/wakatara/harsh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4970bfbe09cef8a9f327581be62c92fda2c2157a1d21abc8fa74a0889dd69be9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4970bfbe09cef8a9f327581be62c92fda2c2157a1d21abc8fa74a0889dd69be9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4970bfbe09cef8a9f327581be62c92fda2c2157a1d21abc8fa74a0889dd69be9"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a4af4c10822801a92da04234ded9dc057cd9dbaddbd9340f2df996172349a85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a4457ae4e9ed3a0d9afbe3e0ec47361ac42a76383601b52f361c573bcacaf6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cefaa4785482438e69b1ce4fb87e04d085472de398590127ea16989ca61e4b8c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/wakatara/harsh/cmd.version=#{version}")
  end

  test do
    assert_match "Welcome to harsh!", shell_output("#{bin}/harsh todo")
    assert_match version.to_s, shell_output("#{bin}/harsh --version")
  end
end