class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https:github.comevilmartianslefthook"
  url "https:github.comevilmartianslefthookarchiverefstagsv1.6.13.tar.gz"
  sha256 "3a57805460e079cbde5c135a16fec45166ac758eeb1d07facbdf4dfaed2cc514"
  license "MIT"
  head "https:github.comevilmartianslefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f14f924ef82c5f94d4745926c0b0c75383e642a26b2c5cc48d0ee3ceb291fe04"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b94e2c51cbf82357ad148661701d7f7c841f0f507dde4c2c4bc750b55f127fd2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3f2774d8b63c1abaa97d7fa2ca0ea2a5f24deb57c51527ac63b5eb9d0023b4a"
    sha256 cellar: :any_skip_relocation, sonoma:         "9b4958ad8fe120b852b900a36808df70e8ab5a5baf8e73cae48f6e66c2560280"
    sha256 cellar: :any_skip_relocation, ventura:        "b61f9a9bba08b5179f9f246c3515a48190729889596618489e6aecd100a1cb20"
    sha256 cellar: :any_skip_relocation, monterey:       "c86c87ed576c41e37c8f2a101f8c4fcda2c03b403ab90c5fbde6968d91c6dd99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfa8b5204c8bf6f294011ab859b33f2c1cb8518ffcf8b08010e914bb14453ba5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin"lefthook", "install"

    assert_predicate testpath"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}lefthook version")
  end
end